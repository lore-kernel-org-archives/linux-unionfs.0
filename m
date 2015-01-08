From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] ovl: Fix kernel panic while mounting overlayfs
Date: Thu, 8 Jan 2015 14:51:52 +0100
Message-ID: <CAJfpegsOgKCB69iK60ARdimVcU8FLthwxuAF_ygpW+W-bMYNvg@mail.gmail.com>
References: <54AB69FD.6060501@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qa0-f44.google.com ([209.85.216.44]:59885 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359AbbAHNvx (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 8 Jan 2015 08:51:53 -0500
Received: by mail-qa0-f44.google.com with SMTP id bm13so7275374qab.3
        for <linux-unionfs@vger.kernel.org>; Thu, 08 Jan 2015 05:51:53 -0800 (PST)
In-Reply-To: <54AB69FD.6060501@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: hujianyang <hujianyang@huawei.com>
Cc: linux-unionfs@vger.kernel.org, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>

On Tue, Jan 6, 2015 at 5:52 AM, hujianyang <hujianyang@huawei.com> wrote:
> The function ovl_fill_super() in recently multi-layer support
> version will incorrectly return 0 at error handling path and
> then cause kernel panic.


Applied.

Thanks,
Miklos
