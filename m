From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: NFS/ro: mv: cannot move 'foo' to a subdirectory of itself, 'bar'
Date: Wed, 29 Jun 2016 16:21:56 +0200
Message-ID: <CAJfpegs2F1oDaBrZnfg=UK1NyefU=TnY7eF+rssCM_0XsL5H4A@mail.gmail.com>
References: <20160613130710.57321936@gmail.com> <CAJfpegsxnqOpDUDHwKd4p+ZJMkBTAVKgjpNBhNqP0e2uZvrkVQ@mail.gmail.com>
 <20160618133204.2c98c65a@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:32845 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbcF2OV6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 29 Jun 2016 10:21:58 -0400
Received: by mail-ob0-f169.google.com with SMTP id xn17so27639506obc.0
        for <linux-unionfs@vger.kernel.org>; Wed, 29 Jun 2016 07:21:58 -0700 (PDT)
In-Reply-To: <20160618133204.2c98c65a@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: =?UTF-8?Q?Andr=C3=A9_Roth?= <neolynx@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Sat, Jun 18, 2016 at 1:32 PM, Andr=C3=A9 Roth <neolynx@gmail.com> wr=
ote:
>
> Hello,
>
>>  # echo 'module overlay +mp' > /sys/kernel/debug/dynamic_debug/contr=
ol
>>  # strace -o /tmp/strace mv foo bar
>>  # dmesg | grep overlay > /tmp/debug
>>
>> And post the /tmp/strace and /tmp/debug files.
>
> # strace -o /tmp/strace mv OVERLAYFS foo
> mv: cannot move =E2=80=98OVERLAYFS=E2=80=99 to a subdirectory of itse=
lf, =E2=80=98foo=E2=80=99
>
> files attached...

Overlayfs cannot create a whiteout on the upper fs.

Do you have

  CONFIG_EXT4_USE_FOR_EXT2=3Dy

in your kernel's .config?  If not, then you should.

You'll also need

  a4859d75944a ("ovl: fix dentry leak for default_permissions")

from the overlayfs-linus branch of

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git

otherwise "default_permissions" will misbehave.

Thanks,
Miklos
