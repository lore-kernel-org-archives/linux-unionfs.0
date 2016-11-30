From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2] ovl: create directories inside merged parent opaque
Date: Wed, 30 Nov 2016 12:09:56 +0100
Message-ID: <CAJfpegtG8z1AN8SXQG3e=dXCMwa58AdL8pyOYnffE-85X04+Dw@mail.gmail.com>
References: <CAJfpegs--UYZrZG4KM8uigs5nL-Q_jD3+ssvQMRRSOK4HPWpsw@mail.gmail.com>
 <1479747454-2273-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:36193 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934003AbcK3LJ6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 30 Nov 2016 06:09:58 -0500
Received: by mail-oi0-f41.google.com with SMTP id v84so224618949oie.3
        for <linux-unionfs@vger.kernel.org>; Wed, 30 Nov 2016 03:09:58 -0800 (PST)
In-Reply-To: <1479747454-2273-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Mon, Nov 21, 2016 at 5:57 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> The benefit of making directories opaque on creation
> is that lookups can stop short when they reach the
> original created directory, instead of continue lookup
> the entire depth of parent directory stack.
>
> The best case is overlay with N layers, performing
> lookup for first level directory, which exists only in upper.
> In that case, there will be only one lookup instead of N.

I split this up, changed it around a bit and pushed the result to
overlayfs-next.

Thanks,
Miklos
