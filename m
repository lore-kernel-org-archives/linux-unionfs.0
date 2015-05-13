From: Jordi Pujol Palomer <jordipujolp@gmail.com>
Subject: Re: Overalyfs regression in 4.0
Date: Wed, 13 May 2015 20:19:36 +0200
Message-ID: <20150513201936.22026b44@gmail.com>
References: <CA+5PVA5uqoJjj24oUT=KMiVfytC7yyRtOggagv-5wUUcgG8iRA@mail.gmail.com>
	<20150513151101.GA19583@tucsk.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:35695 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbbEMSTl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 13 May 2015 14:19:41 -0400
In-Reply-To: <20150513151101.GA19583@tucsk.suse.de>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Josh Boyer <jwboyer@fedoraproject.org>, Miklos Szeredi <mszeredi@suse.cz>, Vincent Batts <vbatts@gmail.com>, David Howells <dhowells@redhat.com>, linux-unionfs@vger.kernel.org, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>

Hello,

Tested-by: Jordi Pujol Palomer <jordipujolp@gmail.com>

Have compiled the version 4.0.3 adding this patch, it works in a
Live OS,

# rmdir /mnt/
# mkdir -p /mnt
# touch /mnt/file
# rmdir /mnt/
rmdir: failed to remove =E2=80=98/mnt/=E2=80=99: Directory not empty
# uname -a
Linux pcjordi 4.0.3-1-haswell-lnet-amd64 #1 SMP PREEMPT Wed May 13 19:3=
8:19 CEST 2015 x86_64 GNU/Linux
#=20

Thanks,

Jordi Pujol


EL Wed, 13 May 2015 17:11:01 +0200
Miklos Szeredi <miklos@szeredi.hu> escrigu=C3=A9:

> ---
> Subject: ovl: don't remove non-empty opaque directory
> From: Miklos Szeredi <mszeredi@suse.cz>
>=20
> When removing an opaque directory we can't just call rmdir() to check
> for emptyness, because the directory will need to be replaced with a
> whiteout. The replacement is done with RENAME_EXCHANGE, which doesn't
> check emptyness.
>=20
> Solution is just to check emptyness by reading the directory.  In the
> future we could add a new rename flag to check for emptyness even for
> RENAME_EXCHANGE to optimize this case.
>=20
> Reported-by: Vincent Batts <vbatts@gmail.com>
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> Fixes: 263b4a0fee43 ("ovl: dont replace opaque dir")
> Cc: <stable@vger.kernel.org> # v4.0+
> ---
