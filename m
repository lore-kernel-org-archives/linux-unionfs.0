From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] ovl: create all new directories opaque
Date: Mon, 21 Nov 2016 14:38:16 +0100
Message-ID: <CAJfpegsSfst1_9GgJvar0xVOnVLHdE=cMvTa0MhtdbbteYaxZA@mail.gmail.com>
References: <1479733445-15795-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:36076 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754079AbcKUNiS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 21 Nov 2016 08:38:18 -0500
Received: by mail-oi0-f44.google.com with SMTP id v84so160077779oie.3
        for <linux-unionfs@vger.kernel.org>; Mon, 21 Nov 2016 05:38:17 -0800 (PST)
In-Reply-To: <1479733445-15795-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Mon, Nov 21, 2016 at 2:04 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> There is really no good reason why not to make all
> directories opaque from birth.
>
> The benefit of making directiories opaque on creation
> is that lookups can stop short when they reach the
> original created directory.
>
> The best case is overlay with N layers, performing
> lookup for first level directory, which exists only in upper.
> In that case, there will be only one lookup instead of N.

That's true for directories created in a merged dir.  Directories
created in an opaque dir get no such advantage and creating the xattr
will consume space and time.

So this should at least be conditional on the state of the parent.

Thanks,
Miklos
