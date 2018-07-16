Return-Path: <adityakali@google.com>
MIME-Version: 1.0
References: <20180712213230.157085-1-adityakali@gooogle.com> <CAOQ4uxj9dvgzVg3EX0q9qX6U4C-DJbs1Ph+Pj+o=8ubmYO0q8A@mail.gmail.com>
In-Reply-To: <CAOQ4uxj9dvgzVg3EX0q9qX6U4C-DJbs1Ph+Pj+o=8ubmYO0q8A@mail.gmail.com>
From: Aditya Kali <adityakali@google.com>
Date: Mon, 16 Jul 2018 13:14:16 -0700
Message-ID: <CAGr1F2EKAQ-_2BZnBMfiS=b5=R_0G0Ka6LNRZ6nRHsoQtyTFOQ@mail.gmail.com>
Subject: Re: [PATCH] overlayfs: fix warning in ovl_iterate
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: amir73il@gmail.com
Cc: miklos@szeredi.hu, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Hi Amir,

On Fri, Jul 13, 2018 at 6:09 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Fri, Jul 13, 2018 at 12:32 AM, Aditya Kali <adityakali@google.com> wro=
te:
> > From: Aditya Kali <adityakali@google.com>
> >
> > In ovl_iterate() funciton, we were calling ovl_cache_get() on dentries
> > marked OVL_IMPURE which are not refcounted. This results in triggering
> > WARN_ON(cache->refcount <=3D 0).
>
> Aditya,
>
> Thanks for the report, but I am afraid your analysis is inaccurate and
> the fix is flat out wrong, so let's try to better understand what is goin=
g on.
>
> First of all, the WARNING triggered by your test in WARN_ON(!cache->refco=
unt)
> at line 415 of  ovl_cache_get() and not the warning in ovl_cache_put().
>
> Your statement that dir marked OVL_IMPURE have non refcounted
> dir cache is not accurate.
> This statement is only true for dirs that are !ovl_dir_is_real() AND
> marked OVL_IMPURE, in which case od->cache should be NULL
> and therefore ovl_cache_put() is not concerned.
>
I completely missed that.

> Since your test case hits the WARN_ON in ovl_cache_get() it suggests
> that the dir was ovl_dir_is_real(), got a dir cache initialized with
> ovl_cache_get_impure() and then later became !ovl_dir_is_real()
> and got passed into  ovl_cache_get() with an unexpected type
> of dir cache.
>
> Directory can only become !ovl_dir_is_real() on copy up and if dir
> was not upper prior to copy up, it could not have been OVL_IMPURE
> either. However, if ovl_iterate() is called with non zero ctx->pos,
> od->is_real will not be updated, but OVL_IMPURE is checked again.
> Meaning that if chown -R iterates on a bunch of files, chowns them
> and then continues to iterate on more files, directory will become
> OVL_IMPURE, so second ovl_iterate() call with non zero ctx->pos
> will initialize an impure dir cache and then on following ls -l we will
> hit the WARNING.
>
> It will be nice if you can add traces in the relevant functions to prove
> this is what's happening in your test case.
>

Thanks for that explanation. I will admit that my knowledge about
overlayfs is very limited.
My initial hypothesis was based on some tracing I had added that would trig=
ger a
    WARN_ON(ovl_test_flag(OVL_IMPURE, d_inode(dentry))
in ovl_cache_get() and also in ovl_cache_put().

But your explanation for the root cause makes sense.

> > It can be reproduced by running the following command (on system with
> > docker using overlay2 graph driver):
> >
> >   docker run --rm drupal:8.5.4-fpm-alpine \
> >     sh -c 'cd /var/www/html/vendor/symfony && chown -R www-data:www-dat=
a . && ls -l .'
>
> It's nice to have a one liner reproducer, but if you can come up with
> a simple script reproducer that does not include docker that would be
> even nicer.
> If you write an xfstest for the reproducer you really get the praises ;-)
>

Will try to convert it to xfstests.

> >
> >   # dmesg shows
> >
> >   [  509.446081] WARNING: CPU: 3 PID: 4964 at fs/overlayfs/readdir.c:41=
5 ovl_iterate+0x25b/0x270 [overlay]
> >   [  509.455437] Modules linked in: veth ipt_MASQUERADE nf_conntrack_ne=
tlink nfnetlink xfrm_user xfrm_algo iptable_nat nf_conntrack_ipv4 nf_defrag=
_ipv4 nf_nat_ipv4 xt_addrtype iptable_filter xt_conntrack nf_nat nf_conntra=
ck libcrc32c br_netfilter bridge stp llc overlay sb_edac crct10dif_pclmul c=
rc32_pclmul ghash_clmulni_intel pcbc aesni_intel aes_x86_64 crypto_simd cry=
ptd evdev glue_helper pvpanic sg serio_raw snd_pcsp button snd_pcm snd_time=
r snd soundcore intel_rapl_perf ip_tables x_tables autofs4 ext4 crc32c_gene=
ric crc16 mbcache jbd2 fscrypto sd_mod virtio_scsi virtio_net net_failover =
scsi_mod failover crc32c_intel virtio_pci psmouse virtio_ring i2c_piix4 vir=
tio
> >   [  509.514107] CPU: 3 PID: 4964 Comm: ls Not tainted 4.18.0-rc4+ #1
> >   [  509.520217] Hardware name: Google Google Compute Engine/Google Com=
pute Engine, BIOS Google 01/01/2011
> >   [  509.529545] RIP: 0010:ovl_iterate+0x25b/0x270 [overlay]
> >   [  509.534899] Code: ff 89 44 24 04 e8 c5 f7 ff ff 4c 89 f7 e8 6d d0 =
9e df 4c 63 74 24 04 eb a2 49 8b 06 48 85 c0 74 09 48 83 c0 01 49 89 06 eb =
91 <0f> 0b eb f3 44 89 f0 e9 9f fe ff ff 66 0f 1f 84 00 00 00 00 00 0f
> >   [  509.553889] RSP: 0018:ffffa677c3f1fe40 EFLAGS: 00010246
> >   [  509.559228] RAX: 0000000000000000 RBX: ffff8acee1e99480 RCX: ffff8=
acf57973c40
> >   [  509.566483] RDX: ffffffff00000001 RSI: ffff8acee1ee8020 RDI: ffff8=
acee1e99480
> >   [  509.573754] RBP: ffffa677c3f1fed0 R08: 0000000000000000 R09: 00000=
00000000000
> >   [  509.581000] R10: ffffa677c3f1fe80 R11: 0000000000000000 R12: ffff8=
acf3aa7f4c0
> >   [  509.588239] R13: ffff8acf586b5a00 R14: ffff8acf3e02a240 R15: 00000=
00000000000
> >   [  509.595477] FS:  00007fe259795b88(0000) GS:ffff8acf7fcc0000(0000) =
knlGS:0000000000000000
> >   [  509.603669] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >   [  509.609527] CR2: 00007fe25954086a CR3: 0000000795746003 CR4: 00000=
000001606e0
> >   [  509.616787] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000=
00000000000
> >   [  509.624025] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000=
00000000400
> >   [  509.631263] Call Trace:
> >   [  509.633832]  iterate_dir+0x172/0x190
> >   [  509.637515]  ksys_getdents64+0x9d/0x120
> >   [  509.641457]  ? syscall_trace_enter+0x1ae/0x2c0
> >   [  509.646009]  ? iterate_dir+0x190/0x190
> >   [  509.649864]  ? __x64_sys_getdents64+0x16/0x20
> >   [  509.654331]  __x64_sys_getdents64+0x16/0x20
> >   [  509.658618]  do_syscall_64+0x55/0x100
> >   [  509.662386]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >   [  509.667545] RIP: 0033:0x7fe25952740e
> >   [  509.671224] Code: 0f 05 eb 02 89 18 48 89 d0 5b c3 53 8b 47 14 49 =
89 f8 39 47 10 48 8d 77 20 7c 37 48 63 3f ba 00 08 00 00 b8 d9 00 00 00 0f =
05 <85> c0 48 89 c3 7f 15 c1 e8 1f 74 3a 83 fb fe 74 35 f7 db e8 89 09
> >   [  509.690203] RSP: 002b:00007ffd0d30fc60 EFLAGS: 00000246 ORIG_RAX: =
00000000000000d9
> >   [  509.697892] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007=
fe25952740e
> >   [  509.705132] RDX: 0000000000000800 RSI: 00007fe2597961e0 RDI: 00000=
00000000003
> >   [  509.712465] RBP: 0000000000000000 R08: 00007fe2597961c0 R09: 00000=
00000000000
> >   [  509.719702] R10: 0000000000000000 R11: 0000000000000246 R12: 00005=
582eb183bc0
> >   [  509.726956] R13: 00007fe2597961c0 R14: 0000000000000000 R15: 00000=
00000000001
> >   [  509.734199] ---[ end trace 60478fe83a958f8f ]---
> >
> > Also reported at https://bugzilla.redhat.com/show_bug.cgi?id=3D1539540.
> >
> > Address this by making sure ovl_cache_get_impure() is called instead fo=
r
> > the OVL_IMPURE dentries. Also handles OVL_IMPURE case in ovl_cache_put(=
).
> >
> > Fixes: 4edb83bb1041 ('ovl: constant d_ino for non-merge dirs')
> >
> > Signed-off-by: Aditya Kali <adityakali@google.com>
> > ---
> >  fs/overlayfs/readdir.c | 20 ++++++++++++++++----
> >  1 file changed, 16 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> > index ef1fe42ff7bb..4e9ce0ccf1f1 100644
> > --- a/fs/overlayfs/readdir.c
> > +++ b/fs/overlayfs/readdir.c
> > @@ -241,10 +241,18 @@ void ovl_dir_cache_free(struct inode *inode)
> >  static void ovl_cache_put(struct ovl_dir_file *od, struct dentry *dent=
ry)
> >  {
> >         struct ovl_dir_cache *cache =3D od->cache;
> > +       bool is_impure =3D ovl_test_flag(OVL_IMPURE, d_inode(dentry));
> >
> > -       WARN_ON(cache->refcount <=3D 0);
> > -       cache->refcount--;
> > -       if (!cache->refcount) {
> > +       /*
> > +        * OVL_IMPURE dentry cache is not refcounted. So free it
> > +        * unconditionally.
> > +        */
> > +       if (!is_impure) {
> > +               WARN_ON(cache->refcount <=3D 0);
> > +               cache->refcount--;
> > +       }
> > +
>
> Irrelevant - od->cache is never set to a non refcounted dir cache.
>
> > +       if (!cache->refcount || is_impure) {
> >                 if (ovl_dir_cache(d_inode(dentry)) =3D=3D cache)
> >                         ovl_set_dir_cache(d_inode(dentry), NULL);
> >
> > @@ -737,7 +745,11 @@ static int ovl_iterate(struct file *file, struct d=
ir_context *ctx)
> >         if (!od->cache) {
> >                 struct ovl_dir_cache *cache;
> >
> > -               cache =3D ovl_cache_get(dentry);
> > +               if (ovl_test_flag(OVL_IMPURE, d_inode(dentry)))
> > +                       cache =3D ovl_cache_get_impure(&file->f_path);
> > +               else
> > +                       cache =3D ovl_cache_get(dentry);
> > +
>
> Totally wrong. If dir is_real() it needs a merged dir cache from
> ovl_cache_get().
>
> Please try attached patch.
> It is works for you, feel free to add your report to commit message
> add your Signed-off-by and post the patch.
> Or let me know it works and I will post the patch with your Tested-by tag=
.
>

I tested the patch and it seems to address the issue. It would be
great if you can send the patch with clearer explanation for the root
cause.
You can add
Tested-by: Aditya Kali <adityakali@google.com>

Would that be ok?

> Thanks,
> Amir.


Thanks!
--=20
Aditya
