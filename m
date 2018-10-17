Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <f6de5a77786759a7308ec8dc6cfe41c6@agner.ch> <CAJfpegvn9pXJ9EULD-+HXJJNkH58CSB5TEhpv3udHFo47BqeNQ@mail.gmail.com>
In-Reply-To: <CAJfpegvn9pXJ9EULD-+HXJJNkH58CSB5TEhpv3udHFo47BqeNQ@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 17 Oct 2018 18:24:17 +0300
Message-ID: <CAOQ4uxgcsHXZ3ctE1NNMey_y_LNagtx_n+Tdq7SApT6EgLsd0Q@mail.gmail.com>
Subject: Re: WARNING: possible recursive locking detected in mnt_want_write/mnt_want_write_file_path
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, stefan@agner.ch, Greg KH <gregkh@linuxfoundation.org>, Sasha Levin <levinsasha928@gmail.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Oct 17, 2018 at 11:29 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> Cc: linux-unionfs@vger
>
> On Wed, Oct 17, 2018 at 10:00 AM, Stefan Agner <stefan@agner.ch> wrote:
> > Hi,
> >
> > I noticed this warning since we moved to 4.18. It appears when
> > using Docker (which uses overlayfs). Is this a known issue?
> >
> > [  543.235366] WARNING: possible recursive locking detected
> > [  543.240747] 4.18.14 #1 Not tainted
> > [  543.244195] --------------------------------------------
> > [  543.249573] dockerd/522 is trying to acquire lock:
> > [  543.254426] 86b0f89c (sb_writers#7){.+.+}, at: mnt_want_write+0x20/0x4c
> > [  543.261152] but task is already holding lock:
> > [  543.267053] 86b0f89c (sb_writers#7){.+.+}, at: mnt_want_write_file_path+0x24/0x54
> > [  543.274641] other info that might help us debug this:
> > [  543.281242]  Possible unsafe locking scenario:
> > [  543.287227]        CPU0
> > [  543.289706]        ----
> > [  543.292183]   lock(sb_writers#7);
> > [  543.295547]   lock(sb_writers#7);
> > [  543.298912]  *** DEADLOCK ***
> > [  543.306825]  May be due to missing lock nesting notation
> > [  543.315594] 2 locks held by dockerd/522:
> > [  543.320487]  #0: 86b0f89c (sb_writers#7){.+.+}, at: mnt_want_write_file_path+0x24/0x54
> > [  543.330353]  #1: fbe4681b (&ovl_i_mutex_key[depth]){+.+.}, at: chown_common+0xf8/0x1c0

This is a stable tree regression because upstream commit
a6795a585929 vfs: fix freeze protection in mnt_want_write_file() for overlayfs

SHOULD NOT have been applied to kernel <= 4.18

Miklos,

You must have confused "the algorithm" by including a "fix" commit in
rc1 pull request
without mentioning that it "Fixes" a commit in the same pull request.
It probably didn't help that the commit applied cleanly to the wrong
function :-/

Upstream commit a6795a585929:
@@ -441,10 +441,10 @@ int mnt_want_write_file(struct file *file)
 {
        int ret;

-       sb_start_write(file->f_path.mnt->mnt_sb);
+       sb_start_write(file_inode(file)->i_sb);

Backported v4.18.14 commit 5e1002ab5c9b:
@@ -446,10 +446,10 @@ int mnt_want_write_file_path(struct file *file)
 {
        int ret;

-       sb_start_write(file->f_path.mnt->mnt_sb);
+       sb_start_write(file_inode(file)->i_sb);

Ouch! Is there a way for git/quilt to raise a red flag in cases like this?

I could reproduce another lockdep warning on v4.18.14 with xfstest
overlay/030, which is fixed by reverting this commit.

Stefan,

Can you verify that reverting that commit solved the problem for you?

Thanks,
Amir.
