From: "J. R. Okajima" <hooanon05g@gmail.com>
Subject: Re: [GIT PULL] overlayfs update for 4.14
Date: Sun, 17 Sep 2017 23:38:15 +0900
Message-ID: <14181.1505659095@jrobl>
References: <20170913140528.GA19278@veci.piliscsaba.szeredi.hu> <CA+55aFzgQWNMc8Mx1SvCxt53wWJc67qB0uo95=VC1eivmG=YxA@mail.gmail.com> <CAJfpegtYjNyW1HnF2PAdmRWB4nq3eTF9O5-H2tnztZhagVW+Uw@mail.gmail.com> <CA+55aFzzKg17=RYTUomF9Fsy0mM5Acqkak0EZJPivZ5+oZErwA@mail.gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFzzKg17=RYTUomF9Fsy0mM5Acqkak0EZJPivZ5+oZErwA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

Linus Torvalds:
> On Wed, Sep 13, 2017 at 11:46 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > d_real() is currently is *the* overlayfs-op:
>
> I know. And it's ugly as #%^! hell.
>
> We don't want to  make it uglier.
>
> And honestly, if you think that "it's only for overlayfs, so I can do
> anything I damn well want to this p[iece of shit" is valid, then I
> want to re-educate you. That is *not* how the VFS layer works.

Miklos,

I've just read your experimental patch to remove ->d_real(). I believe
it is the way to go. Moreover I'd suggest you to re-consider these
things.

- d_real_inode(), d_backing_inode(), and locks_inode()
  I don't think it a good idea for VFS and other modules to care "which
  inode I should use" issue. Ideally they should call d_inode() and
  file_inode() only as they used to.

- RENAME_WHITEOUT flag for user-space
  Why does this flag visible to users? It is a pure internal flag, isn't
  it? When and what for do users specify this flag?

Git-grepping the overlayfs related changes in other modules, I'd also
suggest you to re-consider these.

v4.2
4bacc9c 2015-06-19 overlayfs: Make f_path always point to the overlay and f_inode to the underlay

v4.6
54d5ca8 2016-05-10 vfs: add vfs_select_inode() helper
d101a12 2016-03-26 fs: add file_dentry()

v4.7
a118084 2016-05-20 vfs: add d_real_inode() helper

v4.8
c1892c3 2016-08-03 vfs: fix deadlock in file_remove_privs() on overlayfs

v4.9
4d0c5ba 2016-09-16 vfs: do get_write_access() on upper layer of overlayfs
c568d68 2016-09-16 locks: fix file locking on overlayfs
f3fbbb0 2016-09-16 fsnotify: support overlayfs
598e3c8 2016-09-16 vfs: update ovl inode before relatime check

v4.12
78757af 2017-04-20 vfs: ftruncate check IS_APPEND() on real upper inode

v4.13
ad0af71 2017-07-04 vfs: introduce inode 'inuse' lock


J. R. Okajima
