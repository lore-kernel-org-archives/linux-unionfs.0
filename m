From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 2/2] ovl: constant d_ino across copy up
Date: Fri, 19 May 2017 15:37:23 +0200
Message-ID: <CAJfpegvqomZq+M6RGBGfj_oHieWL2Hi6L6htsyC4hCmSkh-GOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35065 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751560AbdESNhZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 19 May 2017 09:37:25 -0400
Received: by mail-oi0-f68.google.com with SMTP id m17so12389907oik.2
        for <linux-unionfs@vger.kernel.org>; Fri, 19 May 2017 06:37:25 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, "open list:OVERLAY FILESYSTEM" <linux-unionfs@vger.kernel.org>

On Fri, May 19, 2017 at 3:09 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Fri, May 19, 2017 at 3:22 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:

> Right, so perhaps mounter's creds isn't the right choice.
> What we need is to install new credentials with elevated permissions
> for lookup. Can we do that?
>
> But looking at this from another perspective, if user can readdir,
> but cannot lookup inside it, then user cannot stat the files listed by
> readdir and therefore user cannot observe the st_ino/d_ino
> inconsistency due to lookup failure. If we say that we don't really
> care about this corner case, then we silently ignore -EACCESS
> and report the upper d_ino.
>
> But I am mostly debating this for the sake of debating. If you prefer
> to do this "by hand" because it's the "right thing to do", that seems
> like a good enough reason to me. As I wrote, this reeks of a layer
> violation that may come back to bite us in the future,  even if right now,
> we cannot figure out why.

Well, even if we go by the route of looking up the overlay dentry, we
shoudn't be hacking around the permission checks (yeah, overlayfs
started out doing that, because I didn't know better at the time).
Instead we can export __lookup_hash() and use that.

But I simply don't know which route is better.  There's a tradeoff
between memory use and performance, but all depends on usage patterns.
Probably doesn't matter much, so just choose the one which you feel
better about.

Thanks,
Miklos


Thanks,
Miklos
