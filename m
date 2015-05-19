From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: linux / overlay / OpenWrt / problems with full working dir
Date: Tue, 19 May 2015 14:35:47 +0200
Message-ID: <CAJfpegvJCrXDWeS0TNUFTfDatotz-6kWw5pFbn3Q0rYvLwyw=A@mail.gmail.com>
References: <20150519075120.GL28644@medion.lan>
	<20150519090339.GB9960@tucsk>
	<20150519120018.GM28644@medion.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qc0-f175.google.com ([209.85.216.175]:34069 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399AbbESMfs (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 19 May 2015 08:35:48 -0400
Received: by qctt3 with SMTP id t3so5982433qct.1
        for <linux-unionfs@vger.kernel.org>; Tue, 19 May 2015 05:35:47 -0700 (PDT)
In-Reply-To: <20150519120018.GM28644@medion.lan>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, openwrt-devel@lists.openwrt.org

On Tue, May 19, 2015 at 2:00 PM, Bastian Bittorf <bittorf@bluebottle.com> wrote:

> please apply it on your git, and we will cherrypick/backport it for OpenWrt.
> (and close ticket https://dev.openwrt.org/ticket/19564)

Pushed to:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git
overlayfs-current

Thanks,
Miklos
