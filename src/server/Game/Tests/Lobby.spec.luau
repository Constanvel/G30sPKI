--!strict
return function()
 local Lobby=require(script.Parent.Parent.LobbyService)
 local config=require(game.ReplicatedStorage.Shared.GameConfig)
 local Chapter=require(script.Parent.Parent.ChapterService)
 local lobby=Lobby.new(config)
 local count=0
 local function check(ok,message) assert(ok,message);count+=1 end
 local players={}
 for n=1,5 do players[n]={UserId=n,DisplayName="Pemain "..n} end
 for n=1,4 do check(lobby:join(players[n]),"Empat pemain dapat bergabung") end
 check(not lobby:join(players[5]),"Kapasitas empat ditegakkan")
 check(not lobby:request(players[1],"role",lobby.revision,"invalid"),"Peran tak dikenal ditolak")
 check(not lobby:request(players[1],"role",lobby.revision,"bima"),"Peran ganda ditolak")
 check(not lobby:request(players[1],"ready",0,true),"Revision lama ditolak")
 check(not lobby:request(players[1],"ready",lobby.revision,"true"),"Payload boolean wajib")
 check(not lobby:canStart(),"Regu belum siap")
 for n=1,4 do check(lobby:request(players[n],"ready",lobby.revision,true),"Status siap dapat diubah") end
 check(not lobby:request(players[2],"launch",lobby.revision),"Hanya host memulai")
 check(lobby:request(players[1],"launch",lobby.revision),"Host memulai regu siap")
 check(not lobby:request(players[1],"launch",lobby.revision),"Mulai ganda ditolak")
 check(not lobby:join(players[5]),"Tidak bergabung saat misi berjalan")
 local service=Chapter.new({id="prolog",objectives={{id="a"},{id="b"}}})
 service:startParty({players[1],players[2],players[3],players[4]})
 check(service:acknowledge(players[1],service:snapshot(players[1]).revision),"Regu menyelesaikan intro")
 check(service:snapshot(players[4]).phase=="exploring","Intro dibagi ke semua anggota")
 local stale=service:snapshot(players[2]).revision
 check(service:interact(players[1],"a"),"Interaksi regu sah")
 check(not service:acknowledge(players[2],stale),"Input anggota sebelum perubahan ditolak")
 check(service:snapshot(players[4]).phase=="dialogue","Narasi regu dibagi")
 service:enterMenu(players[4],service:snapshot(players[4]).revision)
 service:acknowledge(players[2],service:snapshot(players[2]).revision)
 check(service:snapshot(players[1]).objectiveIndex==2,"Satu progres objektif bersama")
 check(service:snapshot(players[4]).phase=="menu","Menu personal tidak dipaksa tertutup")
 check(service:resume(players[4],service:snapshot(players[4]).revision),"Anggota kembali ke progres terbaru")
 check(service:snapshot(players[4]).objectiveIndex==2,"Checkpoint tidak mengulang progres lama")
 service:remove(players[1]);lobby:remove(players[1])
 check(lobby.host==players[2],"Host keluar dipindahkan")
 check(service:interact(players[2],"b"),"Misi tetap berlanjut setelah host keluar")
 service:acknowledge(players[2],service:snapshot(players[2]).revision)
 service:finishCinematic(players[2],service:snapshot(players[2]).revision)
 check(service:snapshot(players[4]).phase=="completed","Regu selesai bersama")
 lobby:finish()
 for n=2,4 do lobby:remove(players[n]) end
 check(lobby:join(players[5]),"Server kosong bisa dipakai ulang")
 check(lobby:request(players[5],"ready",lobby.revision,true),"Solo bisa siap")
 check(lobby:request(players[5],"launch",lobby.revision),"Solo tidak dikunci empat peran")
 service:fail(players[2],"Uji kegagalan kamera")
 service:enterMenu(players[4],service:snapshot(players[4]).revision)
 check(not service:snapshot(players[4]).hasCheckpoint,"Error terminal tidak menawarkan resume gagal")
 lobby:finish()
 check(lobby:request(players[5],"ready",lobby.revision,true),"Regu dapat siap setelah kegagalan")
 check(lobby:request(players[5],"launch",lobby.revision),"Regu dapat dimulai ulang setelah kegagalan")
 return tostring(count).." assertions PASS"
end
