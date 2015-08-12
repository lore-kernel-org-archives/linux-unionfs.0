From: Alkis Georgopoulos <alkisg@gmail.com>
Subject: Re: How to specify the mount points for multiple lower layers?
Date: Wed, 12 Aug 2015 16:24:08 +0300
Message-ID: <55CB48F8.5070605@gmail.com>
References: <55C319EC.4080707@gmail.com> <CAJfpegsDUDtRS81d+8e_+WQewvnZoRQ4Mfpw0qFDkdiUFe140w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:33259 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbbHLNYK (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 12 Aug 2015 09:24:10 -0400
Received: by wijp15 with SMTP id p15so217651135wij.0
        for <linux-unionfs@vger.kernel.org>; Wed, 12 Aug 2015 06:24:09 -0700 (PDT)
In-Reply-To: <CAJfpegsDUDtRS81d+8e_+WQewvnZoRQ4Mfpw0qFDkdiUFe140w@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On 12/08/2015 12:39 =CE=BC=CE=BC, Miklos Szeredi wrote:
>
> Create two overlays: one for root and one for home (which includes th=
e
> additional home-fs).
>
> Does that work for you?


Yes, thank you, I wasn't able to do it with the multiple lower layers=20
syntax,
but I was able to do it with multiple overlayfs mounts.

Thanks!
