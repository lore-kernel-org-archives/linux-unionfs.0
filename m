From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 07/10] ovl: mount overlay read-only on failure to verify
 index dir
Date: Fri, 14 Jul 2017 12:53:59 +0200
Message-ID: <CAJfpegsoy_BSp4tLph3wOE1o18jdHjEEnz1XOeTjTMRd0SLojQ@mail.gmail.com>
References: <1499777923-29410-1-git-send-email-amir73il@gmail.com>
 <1499777923-29410-8-git-send-email-amir73il@gmail.com> <CAJfpegvR5qZWb6dJRMSL4N-qpbJT1rqN_1KkVZhO4G2AgJWd3g@mail.gmail.com>
 <CAOQ4uxiQ7ONfkbx=buUTaS6bCpDurHk7qB5vj6c9wOesJbS4FQ@mail.gmail.com>
 <CAJfpegsTGkUuRCuJOZh5N8Q5DL0qvFBL5NgNSVYE8XV+5yF4nw@mail.gmail.com> <CAOQ4uxjY-=7RdF1DLibLrHVVWp5bTgCrVORn-VJngRxmLzBz1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:35753 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753486AbdGNKyC (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 14 Jul 2017 06:54:02 -0400
Received: by mail-oi0-f49.google.com with SMTP id 191so68224623oii.2
        for <linux-unionfs@vger.kernel.org>; Fri, 14 Jul 2017 03:54:01 -0700 (PDT)
In-Reply-To: <CAOQ4uxjY-=7RdF1DLibLrHVVWp5bTgCrVORn-VJngRxmLzBz1w@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Fri, Jul 14, 2017 at 12:35 PM, Amir Goldstein <amir73il@gmail.com> wrote:

> What? always warn on boot? on mount? I donno. To me the comment
> about backward compat in Kconfig seems sufficient and no sysadmin
> can mistakenly set index=on on mount, but as I said, don't know
> enough about downstream to say much.

I meant warning in Kconfig.   I see that there is a warning there, but
it could be made shorter and more explicit.   No need to explain the
hows and whys, just warn that enabling this option is not backward
compatible.

And if distros enable it despite this warning, and it burns their
users, that's their problem.

Thanks,
Miklos
