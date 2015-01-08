From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] ovl: Fix opaque regression in ovl_lookup
Date: Thu, 8 Jan 2015 14:53:52 +0100
Message-ID: <CAJfpegsev1Vat7HMY8iS1u2ZkSQNZ6Jancm84Ldu65ytAZos3A@mail.gmail.com>
References: <54AB9859.6070704@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qg0-f41.google.com ([209.85.192.41]:62675 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310AbbAHNxx (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 8 Jan 2015 08:53:53 -0500
Received: by mail-qg0-f41.google.com with SMTP id e89so2144381qgf.0
        for <linux-unionfs@vger.kernel.org>; Thu, 08 Jan 2015 05:53:52 -0800 (PST)
In-Reply-To: <54AB9859.6070704@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: hujianyang <hujianyang@huawei.com>
Cc: linux-unionfs@vger.kernel.org, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>

On Tue, Jan 6, 2015 at 9:10 AM, hujianyang <hujianyang@huawei.com> wrote:
> Current multi-layer support overlayfs has a regression in
> .lookup(). If there is a directory in upperdir and a regular
> file has same name in lowerdir in a merged directory, lower
> file is hidden and upper directory is set to opaque in former
> case. But it is changed in present code.

Applied.

Thanks,
Miklos
