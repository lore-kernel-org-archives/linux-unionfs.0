From: =?UTF-8?B?QW5kcsOp?= Roth <neolynx@gmail.com>
Subject: Re: NFS/ro: mv: cannot move 'foo' to a subdirectory of itself,
 'bar'
Date: Wed, 29 Jun 2016 23:20:19 +0200
Message-ID: <20160629232019.5bf1d11c@nfsboot>
References: <20160613130710.57321936@gmail.com>
	<CAJfpegsxnqOpDUDHwKd4p+ZJMkBTAVKgjpNBhNqP0e2uZvrkVQ@mail.gmail.com>
	<20160618133204.2c98c65a@gmail.com>
	<CAJfpegs2F1oDaBrZnfg=UK1NyefU=TnY7eF+rssCM_0XsL5H4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:38441 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbcF2VUW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 29 Jun 2016 17:20:22 -0400
Received: by mail-wm0-f46.google.com with SMTP id r201so91466381wme.1
        for <linux-unionfs@vger.kernel.org>; Wed, 29 Jun 2016 14:20:22 -0700 (PDT)
Received: from nfsboot (84.110.106.92.dynamic.wline.res.cust.swisscom.ch. [92.106.110.84])
        by smtp.gmail.com with ESMTPSA id qg5sm5525548wjc.13.2016.06.29.14.20.20
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Jun 2016 14:20:20 -0700 (PDT)
In-Reply-To: <CAJfpegs2F1oDaBrZnfg=UK1NyefU=TnY7eF+rssCM_0XsL5H4A@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>


> Do you have
>=20
>   CONFIG_EXT4_USE_FOR_EXT2=3Dy
>=20
> in your kernel's .config?  If not, then you should. =20

nope

> You'll also need
>=20
>   a4859d75944a ("ovl: fix dentry leak for default_permissions")
>=20
> from the overlayfs-linus branch of
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git =20

works like a charm now :)
=20
> otherwise "default_permissions" will misbehave. =20

thanks for the information !

regards,

 andr=C3=A9
