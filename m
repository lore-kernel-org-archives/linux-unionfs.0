Return-Path: <adityakali@google.com>
Return-Path: <adityakali@google.com>
From: Aditya Kali <adityakali@google.com>
Subject: [PATCH] overlayfs: fix warning in ovl_iterate
Date: Thu, 12 Jul 2018 14:32:30 -0700
Message-Id: <20180712213230.157085-1-adityakali@gooogle.com>
To: miklos@szeredi.hu
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Aditya Kali <adityakali@google.com>
List-ID: <linux-unionfs@vger.kernel.org>

From: Aditya Kali <adityakali@google.com>

In ovl_iterate() funciton, we were calling ovl_cache_get() on dentries
marked OVL_IMPURE which are not refcounted. This results in triggering
WARN_ON(cache->refcount <= 0).
It can be reproduced by running the following command (on system with
docker using overlay2 graph driver):

  docker run --rm drupal:8.5.4-fpm-alpine \
    sh -c 'cd /var/www/html/vendor/symfony && chown -R www-data:www-data . && ls -l .'

  # dmesg shows

  [  509.446081] WARNING: CPU: 3 PID: 4964 at fs/overlayfs/readdir.c:415 ovl_iterate+0x25b/0x270 [overlay]
  [  509.455437] Modules linked in: veth ipt_MASQUERADE nf_conntrack_netlink nfnetlink xfrm_user xfrm_algo iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype iptable_filter xt_conntrack nf_nat nf_conntrack libcrc32c br_netfilter bridge stp llc overlay sb_edac crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc aesni_intel aes_x86_64 crypto_simd cryptd evdev glue_helper pvpanic sg serio_raw snd_pcsp button snd_pcm snd_timer snd soundcore intel_rapl_perf ip_tables x_tables autofs4 ext4 crc32c_generic crc16 mbcache jbd2 fscrypto sd_mod virtio_scsi virtio_net net_failover scsi_mod failover crc32c_intel virtio_pci psmouse virtio_ring i2c_piix4 virtio
  [  509.514107] CPU: 3 PID: 4964 Comm: ls Not tainted 4.18.0-rc4+ #1
  [  509.520217] Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
  [  509.529545] RIP: 0010:ovl_iterate+0x25b/0x270 [overlay]
  [  509.534899] Code: ff 89 44 24 04 e8 c5 f7 ff ff 4c 89 f7 e8 6d d0 9e df 4c 63 74 24 04 eb a2 49 8b 06 48 85 c0 74 09 48 83 c0 01 49 89 06 eb 91 <0f> 0b eb f3 44 89 f0 e9 9f fe ff ff 66 0f 1f 84 00 00 00 00 00 0f
  [  509.553889] RSP: 0018:ffffa677c3f1fe40 EFLAGS: 00010246
  [  509.559228] RAX: 0000000000000000 RBX: ffff8acee1e99480 RCX: ffff8acf57973c40
  [  509.566483] RDX: ffffffff00000001 RSI: ffff8acee1ee8020 RDI: ffff8acee1e99480
  [  509.573754] RBP: ffffa677c3f1fed0 R08: 0000000000000000 R09: 0000000000000000
  [  509.581000] R10: ffffa677c3f1fe80 R11: 0000000000000000 R12: ffff8acf3aa7f4c0
  [  509.588239] R13: ffff8acf586b5a00 R14: ffff8acf3e02a240 R15: 0000000000000000
  [  509.595477] FS:  00007fe259795b88(0000) GS:ffff8acf7fcc0000(0000) knlGS:0000000000000000
  [  509.603669] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [  509.609527] CR2: 00007fe25954086a CR3: 0000000795746003 CR4: 00000000001606e0
  [  509.616787] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  [  509.624025] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  [  509.631263] Call Trace:
  [  509.633832]  iterate_dir+0x172/0x190
  [  509.637515]  ksys_getdents64+0x9d/0x120
  [  509.641457]  ? syscall_trace_enter+0x1ae/0x2c0
  [  509.646009]  ? iterate_dir+0x190/0x190
  [  509.649864]  ? __x64_sys_getdents64+0x16/0x20
  [  509.654331]  __x64_sys_getdents64+0x16/0x20
  [  509.658618]  do_syscall_64+0x55/0x100
  [  509.662386]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
  [  509.667545] RIP: 0033:0x7fe25952740e
  [  509.671224] Code: 0f 05 eb 02 89 18 48 89 d0 5b c3 53 8b 47 14 49 89 f8 39 47 10 48 8d 77 20 7c 37 48 63 3f ba 00 08 00 00 b8 d9 00 00 00 0f 05 <85> c0 48 89 c3 7f 15 c1 e8 1f 74 3a 83 fb fe 74 35 f7 db e8 89 09
  [  509.690203] RSP: 002b:00007ffd0d30fc60 EFLAGS: 00000246 ORIG_RAX: 00000000000000d9
  [  509.697892] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fe25952740e
  [  509.705132] RDX: 0000000000000800 RSI: 00007fe2597961e0 RDI: 0000000000000003
  [  509.712465] RBP: 0000000000000000 R08: 00007fe2597961c0 R09: 0000000000000000
  [  509.719702] R10: 0000000000000000 R11: 0000000000000246 R12: 00005582eb183bc0
  [  509.726956] R13: 00007fe2597961c0 R14: 0000000000000000 R15: 0000000000000001
  [  509.734199] ---[ end trace 60478fe83a958f8f ]---

Also reported at https://bugzilla.redhat.com/show_bug.cgi?id=1539540.

Address this by making sure ovl_cache_get_impure() is called instead for
the OVL_IMPURE dentries. Also handles OVL_IMPURE case in ovl_cache_put().

Fixes: 4edb83bb1041 ('ovl: constant d_ino for non-merge dirs')

Signed-off-by: Aditya Kali <adityakali@google.com>
---
 fs/overlayfs/readdir.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index ef1fe42ff7bb..4e9ce0ccf1f1 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -241,10 +241,18 @@ void ovl_dir_cache_free(struct inode *inode)
 static void ovl_cache_put(struct ovl_dir_file *od, struct dentry *dentry)
 {
 	struct ovl_dir_cache *cache = od->cache;
+	bool is_impure = ovl_test_flag(OVL_IMPURE, d_inode(dentry));
 
-	WARN_ON(cache->refcount <= 0);
-	cache->refcount--;
-	if (!cache->refcount) {
+	/*
+	 * OVL_IMPURE dentry cache is not refcounted. So free it
+	 * unconditionally.
+	 */
+	if (!is_impure) {
+		WARN_ON(cache->refcount <= 0);
+		cache->refcount--;
+	}
+
+	if (!cache->refcount || is_impure) {
 		if (ovl_dir_cache(d_inode(dentry)) == cache)
 			ovl_set_dir_cache(d_inode(dentry), NULL);
 
@@ -737,7 +745,11 @@ static int ovl_iterate(struct file *file, struct dir_context *ctx)
 	if (!od->cache) {
 		struct ovl_dir_cache *cache;
 
-		cache = ovl_cache_get(dentry);
+		if (ovl_test_flag(OVL_IMPURE, d_inode(dentry)))
+			cache = ovl_cache_get_impure(&file->f_path);
+		else
+			cache = ovl_cache_get(dentry);
+
 		if (IS_ERR(cache))
 			return PTR_ERR(cache);
 
-- 
2.11.0
