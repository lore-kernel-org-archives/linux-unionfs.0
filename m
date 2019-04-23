Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20190423065024.12695-1-jencce.kernel@gmail.com>
In-Reply-To: <20190423065024.12695-1-jencce.kernel@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 23 Apr 2019 13:59:53 +0300
Message-ID: <CAOQ4uxgo-R8CUONFy=e6N8DfbeJb+AJmShJcDd9xgdy69BwZyA@mail.gmail.com>
Subject: Re: [PATCH] ovl: add RWF_NONITIFY flag to skip wrong duplicate
 fanotify event
Content-Type: multipart/mixed; boundary="000000000000c91d620587307ceb"
To: Murphy Zhou <jencce.kernel@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>
List-ID: <linux-unionfs@vger.kernel.org>

--000000000000c91d620587307ceb
Content-Type: text/plain; charset="UTF-8"

On Tue, Apr 23, 2019 at 9:51 AM Murphy Zhou <jencce.kernel@gmail.com> wrote:
>
> Overlays ovl_iter_write calls vfs_iter_write to write on real file,
> in which calls fsnotify_modify on this change, however vfs_write also
> calls fsnotify_modify after ovl_iter_write. The first notification
> sent by vfs_iter_write grabs marks from upper inode and overlay mnt,
> because of its fake path. The second one sent by vfs_write grabs marks
> from ovl inode and ovl mnt.
>
> LTP fanotify06 add modify mark for mnt point, then add ignore modify
> mask on testfile, then truncate and write the file. Because the ignore
> mask is marked on ovl inode, not the upper inode, the first event is not
> masked like the second one. So we get a modification event even with a
> mask on the file.

Care to extend fanotify06 in a similar manner to the way readahead02
was extended to test overlay test case regardless of the base LTP filesystem?

>
> Proposing fixing this by add a new RWF flag to skip fsnotify on this IO.
> vfs_iter_write used by ovl can use this flag to skip one duplicate event.
>

This fix is wrong for several reasons:
- It exports RWF_NONOTIFY to uapi
- It will cause no events at all when overlay writes to file even when user
requested events on upper inode

Please try attached patch.

Thanks,
Amir.

> Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
> ---
>  fs/overlayfs/file.c     | 2 +-
>  fs/read_write.c         | 2 +-
>  include/uapi/linux/fs.h | 5 ++++-
>  3 files changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index 84dd957efa24..0827199a5311 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -242,7 +242,7 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
>         old_cred = ovl_override_creds(file_inode(file)->i_sb);
>         file_start_write(real.file);
>         ret = vfs_iter_write(real.file, iter, &iocb->ki_pos,
> -                            ovl_iocb_to_rwf(iocb));
> +                            ovl_iocb_to_rwf(iocb)|RWF_NONOTIFY);
>         file_end_write(real.file);
>         revert_creds(old_cred);
>
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 61b43ad7608e..aec751cacedf 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -957,7 +957,7 @@ static ssize_t do_iter_write(struct file *file, struct iov_iter *iter,
>                 ret = do_iter_readv_writev(file, iter, pos, WRITE, flags);
>         else
>                 ret = do_loop_readv_writev(file, iter, pos, WRITE, flags);
> -       if (ret > 0)
> +       if (ret > 0 && !(flags & RWF_NONOTIFY))
>                 fsnotify_modify(file);
>         return ret;
>  }
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index 121e82ce296b..103f1a9375f2 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -342,8 +342,11 @@ typedef int __bitwise __kernel_rwf_t;
>  /* per-IO O_APPEND */
>  #define RWF_APPEND     ((__force __kernel_rwf_t)0x00000010)
>
> +/* do not notify this IO */
> +#define RWF_NONOTIFY   ((__force __kernel_rwf_t)0x00000020)
> +
>  /* mask of flags supported by the kernel */
>  #define RWF_SUPPORTED  (RWF_HIPRI | RWF_DSYNC | RWF_SYNC | RWF_NOWAIT |\
> -                        RWF_APPEND)
> +                        RWF_APPEND | RWF_NONOTIFY)
>
>  #endif /* _UAPI_LINUX_FS_H */
> --
> 2.21.0
>

--000000000000c91d620587307ceb
Content-Type: text/plain; charset="US-ASCII";
	name="0001-ovl-use-real-path-for-open_with_fake_path.patch.txt"
Content-Disposition: attachment;
	filename="0001-ovl-use-real-path-for-open_with_fake_path.patch.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_jutoe4h50>
X-Attachment-Id: f_jutoe4h50

RnJvbSBjNTExYTEwM2JhNjY5MGNiZjY3NDhmMjU3MDBjYjhlOTVkZDc3OTgyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbWlyIEdvbGRzdGVpbiA8YW1pcjczaWxAZ21haWwuY29tPgpE
YXRlOiBUdWUsIDIzIEFwciAyMDE5IDEzOjExOjEwICswMzAwClN1YmplY3Q6IFtQQVRDSF0gb3Zs
OiB1c2UgcmVhbCBwYXRoIGZvciBvcGVuX3dpdGhfZmFrZV9wYXRoKCkKCm92bF9vcGVuKCkgdXNl
cyBvcGVuX3dpdGhfZmFrZV9wYXRoKCkgdG8gY3JlYXRlIGEgZmlsZSBvYmplY3Qgd2l0aCBhCmdp
dmVuIHBhdGguICBDdXJyZW50bHkgb3ZlcmxheWZzIHVzZXMgdGhlIG92ZXJsYXkgcGF0aCBhcyB0
aGUgImZha2UiCnBhdGguIFRoaXMgY2F1c2VzIHNvbWUgaXNzdWVzIHdoZW4gVkZTIGNvZGUgcmVm
ZXJzIHRvIGZpbGUtPmZfcGF0aC0+bW50LgoKT25lIGlzc3VlLCByZXBvcnRlZCBieSBNdXJwaHkg
WmhvdSwgaXMgdGhhdCBmc25vdGlmeSBob29rcyBjaGVjawpmb3IgbW91bnQgbWFya3MgYWdhaW5z
dCB0aGUgd3JvbmcgdmZzbW91bnQuCgpMaW5rOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51
eC1mc2RldmVsLzIwMTkwNDIzMDY1MDI0LjEyNjk1LTEtamVuY2NlLmtlcm5lbEBnbWFpbC5jb20v
ClJlcG9ydGVkLWJ5OiBNdXJwaHkgWmhvdSA8amVuY2NlLmtlcm5lbEBnbWFpbC5jb20+ClNpZ25l
ZC1vZmYtYnk6IEFtaXIgR29sZHN0ZWluIDxhbWlyNzNpbEBnbWFpbC5jb20+Ci0tLQogZnMvb3Zl
cmxheWZzL2ZpbGUuYyB8IDUgKysrKy0KIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyks
IDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9mcy9vdmVybGF5ZnMvZmlsZS5jIGIvZnMvb3Zl
cmxheWZzL2ZpbGUuYwppbmRleCBkZGZkOTNmMTNjYzUuLmVjOWY4NzYzZmUwOCAxMDA2NDQKLS0t
IGEvZnMvb3ZlcmxheWZzL2ZpbGUuYworKysgYi9mcy9vdmVybGF5ZnMvZmlsZS5jCkBAIC0yOCwx
MCArMjgsMTMgQEAgc3RhdGljIHN0cnVjdCBmaWxlICpvdmxfb3Blbl9yZWFsZmlsZShjb25zdCBz
dHJ1Y3QgZmlsZSAqZmlsZSwKIHsKIAlzdHJ1Y3QgaW5vZGUgKmlub2RlID0gZmlsZV9pbm9kZShm
aWxlKTsKIAlzdHJ1Y3QgZmlsZSAqcmVhbGZpbGU7CisJc3RydWN0IHBhdGggcmVhbHBhdGg7CiAJ
Y29uc3Qgc3RydWN0IGNyZWQgKm9sZF9jcmVkOwogCisJb3ZsX3BhdGhfcmVhbChmaWxlX2RlbnRy
eShmaWxlKSwgJnJlYWxwYXRoKTsKKwogCW9sZF9jcmVkID0gb3ZsX292ZXJyaWRlX2NyZWRzKGlu
b2RlLT5pX3NiKTsKLQlyZWFsZmlsZSA9IG9wZW5fd2l0aF9mYWtlX3BhdGgoJmZpbGUtPmZfcGF0
aCwgZmlsZS0+Zl9mbGFncyB8IE9fTk9BVElNRSwKKwlyZWFsZmlsZSA9IG9wZW5fd2l0aF9mYWtl
X3BhdGgoJnJlYWxwYXRoLCBmaWxlLT5mX2ZsYWdzIHwgT19OT0FUSU1FLAogCQkJCSAgICAgICBy
ZWFsaW5vZGUsIGN1cnJlbnRfY3JlZCgpKTsKIAlyZXZlcnRfY3JlZHMob2xkX2NyZWQpOwogCi0t
IAoyLjE3LjEKCg==
--000000000000c91d620587307ceb--
