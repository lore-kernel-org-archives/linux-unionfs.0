From: Xu Wang <xuw@redhat.com>
Subject: Re: [overlayfs] lockdep splat after mounting overlayfs over
 overlayfs
Date: Thu, 25 Jun 2015 03:24:01 -0400 (EDT)
Message-ID: <1919950089.30883798.1435217041129.JavaMail.zimbra@redhat.com>
References: <558AD301.4070302@yandex-team.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:45699 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbbFYHYE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 25 Jun 2015 03:24:04 -0400
In-Reply-To: <558AD301.4070302@yandex-team.ru>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org

> I've accidentally mounted one overlayfs over another and got obvious
> warning from lockdep: i_mutex lockdep classes are per-fs-type.
>=20
> # mount -t overlay overlay 1 -o
> upperdir=3D1_upper,workdir=3D1_work,lowerdir=3D1_lower
> # mount -t overlay overlay 2 -o upperdir=3D2_upper,workdir=3D2_work,l=
owerdir=3D1
> # ls 2

This reporting is positive, we are not in deadlock situation actually. =
The "2" dir
of overlayfs will call iterate_dir->"1" dir of overlayfs->iterate_dir, =
and the nest
iterate_dir happened on the same file system, so the warning came out.

We'd better make the lower and upper in different fs instance, and this=
 warning
will disappear.

And this lockdep warning happened when the nest iterate_dir call of sam=
e fs(I
mean the same super block). The function check_deadlock in lockdep.c wi=
ll
report the nest lock of same process. If we make the 2_upper and 2_work=
 in
a different fs, no warning comes out.

Thanks,

--=20
George Wang =E7=8E=8B=E6=97=AD

Kernel Quantity Engineer
Red Hat Software (Beijing) Co.,Ltd
IRC:xuw
Tel:+86-010-62608041
Phone:15901231579
9/F, Tower C, Raycom
