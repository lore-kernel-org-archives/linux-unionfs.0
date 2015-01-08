From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Multiple lower layers - presedence?
Date: Thu, 8 Jan 2015 15:10:28 +0100
Message-ID: <CAJfpegud7J1uCGn75r8d0NvOO=M_UKQuK45nZL+yugHKq+njWg@mail.gmail.com>
References: <1997646.dsfVWM3xr5@debian-desktop-mine>
	<13541642.4YrjBhCzAu@debian-desktop-mine>
	<85r3v799yw.fsf@boum.org>
	<54AC986B.6030100@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qg0-f43.google.com ([209.85.192.43]:37150 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbbAHOK3 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 8 Jan 2015 09:10:29 -0500
Received: by mail-qg0-f43.google.com with SMTP id z107so2222196qgd.2
        for <linux-unionfs@vger.kernel.org>; Thu, 08 Jan 2015 06:10:28 -0800 (PST)
In-Reply-To: <54AC986B.6030100@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: hujianyang <hujianyang@huawei.com>
Cc: intrigeri <intrigeri@boum.org>, fabian.sturm@aduu.de, linux-unionfs@vger.kernel.org

On Wed, Jan 7, 2015 at 3:22 AM, hujianyang <hujianyang@huawei.com> wrote:
> It seems different in overlayfs. A left-hand lowerdir take precedence
> over any right-hand one in the option line.

Documentation added.

Thanks,
Miklos
