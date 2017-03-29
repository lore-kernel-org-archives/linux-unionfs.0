From: Ralph Sennhauser <ralph.sennhauser@gmail.com>
Subject: Re: [REGRESSION 4.11] Commit d8514d8edb5b ("ovl: copy up regular
 file using O_TMPFILE") breaks ubifs
Date: Wed, 29 Mar 2017 23:26:48 +0200
Message-ID: <20170329232648.0b5bc1e9@gmail.com>
References: <20170328100107.25095af6@gmail.com>
        <CAOQ4uxisw5vWYsdMTNemw=MqNyS2nxfAUkg+UfoGmbE3-he1Ug@mail.gmail.com>
        <20170328124545.3c4b87ff@gmail.com>
        <CAOQ4uxgNfuLN93owdCUJ=9VcU4DKGVEKkEGT7siiem8quVwCsQ@mail.gmail.com>
        <20170328132818.05871b73@gmail.com>
        <CAOQ4uxiC=RXPwSy7NGt+Ri=Eie4-_WsUPk7Sy-sh9RdrGQuesw@mail.gmail.com>
        <20170328141621.6bb2d639@gmail.com>
        <CAOQ4uxg0xRchsNOh1jtbyEdyDDqV3ToCvo=+QuCsD6duGJU_ZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34742 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933043AbdC2V0x (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 29 Mar 2017 17:26:53 -0400
In-Reply-To: <CAOQ4uxg0xRchsNOh1jtbyEdyDDqV3ToCvo=+QuCsD6duGJU_ZQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org, regressions@leemhuis.info, Richard Weinberger <richard@nod.at>, Artem Bityutskiy <dedekind1@gmail.com>, Adrian Hunter <adrian.hunter@intel.com>

On Wed, 29 Mar 2017 22:16:10 +0300
Amir Goldstein <amir73il@gmail.com> wrote:

> On Tue, Mar 28, 2017 at 3:16 PM, Ralph Sennhauser
> <ralph.sennhauser@gmail.com> wrote:
> > On Tue, 28 Mar 2017 08:08:51 -0400
> > Amir Goldstein <amir73il@gmail.com> wrote:
> >  
> >> On Tue, Mar 28, 2017 at 7:28 AM, Ralph Sennhauser
> >> <ralph.sennhauser@gmail.com> wrote:  
> >> > Hi Amir,
> >> >
> >> > On Tue, 28 Mar 2017 07:03:11 -0400
> >> > Amir Goldstein <amir73il@gmail.com> wrote:
> >> >  
> >> >> Overlayfs now uses O_TMPFILE for copy up and it works fine with
> >> >> all the file systems I tested (tmpfs, xfs, ext4).
> >> >> If I am right and O_TMPFILE is broken in ubifs, you are most
> >> >> likely the first person to test it (indirectly by overlayfs).
> >> >>
> >> >> Please try to reproduce the bug with following patch to disable
> >> >> ubifs O_TMPFILE support:
> >> >>
> >> >> --- a/fs/ubifs/dir.c
> >> >> +++ b/fs/ubifs/dir.c
> >> >> @@ -1685,7 +1685,7 @@ const struct inode_operations
> >> >> ubifs_dir_inode_operations = {
> >> >>  #ifdef CONFIG_UBIFS_ATIME_SUPPORT
> >> >>         .update_time = ubifs_update_time,
> >> >>  #endif
> >> >> -       .tmpfile     = ubifs_tmpfile,
> >> >> +       //.tmpfile     = ubifs_tmpfile,
> >> >>  };  
> >> >
> >> > Get a unused warning during build but all seems to be working
> >> > fine now.  
> >>
> >> OK. I'll wait for ubifs developers to fix the bug.
> >> Otherwise, I'll send a proper patch to disable ubifs O_TMPFILE
> >> support. Will add tested-by you.  
> >
> > Sounds like a good plan, there is still time for 4.11-rc5. Fine with
> > you adding my tested-by in case it will come to this.
> >  
> 
> 
> Ralph,
> 
> Can you please try to reproduce the problem with this command
> on ubifs:

Replaced the squashfs with the ubifs overlay with a plain ubifs root.

> 
> # create and link a tmpfile - then remove it
> sudo rm -rf foo; sudo xfs_io -T -c "flink foo" . ; ls -l foo; sudo rm
> foo

next-20170328, obviously without your patch:

  # xfs_io -T -c "flink foo" .
  .: Not supported
  # xfs_io -V
  xfs_io version 4.9.0
  # strace xfs_io -T -c "flink foo" .
  execve("/sbin/xfs_io", ["xfs_io", "-T", "-c", "flink foo", "."], [/* 8 vars */]) = 0
  set_tls(0xb6f17544, 0xbee0ac10, 0xb6f180a0, 0, 0xb6f1749c) = 0
  set_tid_address(0xb6f174b8)             = 2556
  open("/etc/ld-musl-armhf.path", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = -1 ENOENT (No such file or directory)
  open("/lib/libgcc_s.so.1", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
  fcntl64(3, F_SETFD, FD_CLOEXEC)         = 0
  fstat64(3, {st_mode=S_IFREG|0644, st_size=38203, ...}) = 0
  read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0\240;\0\0004\0\0\0"..., 936) = 936
  mmap2(NULL, 106496, PROT_READ|PROT_EXEC, MAP_PRIVATE, 3, 0) = 0xb6e88000
  mmap2(0xb6ea1000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 3, 0x9000) = 0xb6ea1000
  close(3)                                = 0
  mprotect(0xb6f15000, 4096, PROT_READ)   = 0
  mprotect(0x38000, 4096, PROT_READ)      = 0
  clock_gettime(CLOCK_REALTIME, {1490822261, 558395832}) = 0
  open(".", O_RDWR|O_LARGEFILE|O_DIRECTORY|O_TMPFILE) = -1 EOPNOTSUPP (Not supported)
  writev(2, [{iov_base="", iov_len=0}, {iov_base=".", iov_len=1}], 2.) = 1
  writev(2, [{iov_base="", iov_len=0}, {iov_base=":", iov_len=1}], 2:) = 1
  writev(2, [{iov_base="", iov_len=0}, {iov_base=" ", iov_len=1}], 2 ) = 1
  writev(2, [{iov_base="", iov_len=0}, {iov_base="Not supported", iov_len=13}], 2Not supported) = 13
  writev(2, [{iov_base="", iov_len=0}, {iov_base="\n", iov_len=1}], 2
  ) = 1
  exit_group(1)                           = ?
  +++ exited with 1 +++


Need some sleep before looking into what might be going on here.

Ralph

> 
> That's the gist of xfstest generic/004.
> 
> You should expect the same behavior of corrupted fs after boot.
> 
> This issue should be reproduced since kernel 4.9 when ubifs tmpfile
> support was added.
> 
> I hope this info can help the ubifs developers fix the problem
> independently from overlayfs setup.
> 
> Thanks,
> Amir.
