From: "J. R. Okajima" <hooanon05g@gmail.com>
Subject: Re: Stable inode numbers
Date: Tue, 26 Jul 2016 10:51:36 +0900
Message-ID: <22701.1469497896@jrobl>
References: <CAKp8XJ41QeG03E_AW4cxsuyp4-uxrPWAkhKc60OMp3vK2YAADA@mail.gmail.com> <20160722121503.GC20504@veci.piliscsaba.szeredi.hu> <CAKp8XJ4Lfx06of5D4aVkg2up77xESZ9cy0z2PGn1g6-AoHvE8g@mail.gmail.com> <20160725113400.GF20504@veci.piliscsaba.szeredi.hu> <CAKp8XJ7p38vuP_AY7Ky27ui7w=4G5TiwGTB6ZDpfr96dX_hVeQ@mail.gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mfb02-md.ns.itscom.net ([175.177.155.110]:56805 "EHLO
	mfb02-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932AbcGZCBb (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 25 Jul 2016 22:01:31 -0400
Received: from mail03-md.ns.itscom.net (mail03-md.ns.itscom.net [175.177.155.113])
	by mfb02-md.ns.itscom.net (Postfix) with ESMTP id CD33C170EBDA
	for <linux-unionfs@vger.kernel.org>; Tue, 26 Jul 2016 10:51:40 +0900 (JST)
In-Reply-To: <CAKp8XJ7p38vuP_AY7Ky27ui7w=4G5TiwGTB6ZDpfr96dX_hVeQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vito Caputo <vito.caputo@coreos.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org


Vito Caputo:
> ...  That is the lens I view
> overlayfs problems like these through, hence I'd prefer a more general
> solution with stable inode numbers making overlayfs behavior more
> consistent with the filesystems backing it.

You may want to try aufs instead of overlayfs since aufs has a such
feature called XINO (external inode number). It is working well for over
a decade, but some users set 'noxino' mount option which makes aufs not
to use XINO. Because XINO consumes some disk space, and if XINO file is
placed on tmpfs, then it means consuming memory.


J. R. Okajima
