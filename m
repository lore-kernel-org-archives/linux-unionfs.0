From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 2/2] ovl: constant d_ino across copy up
Date: Wed, 24 May 2017 01:40:34 +0300
Message-ID: <CAOQ4uxgbxkJn0QWcRJHk-iWKCJcsUcM+Jt3yUzoeHh-6bzsSWg@mail.gmail.com>
References: <CAJfpegvqomZq+M6RGBGfj_oHieWL2Hi6L6htsyC4hCmSkh-GOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:35135 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1765013AbdEWWkg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 23 May 2017 18:40:36 -0400
Received: by mail-oi0-f46.google.com with SMTP id l18so220557216oig.2
        for <linux-unionfs@vger.kernel.org>; Tue, 23 May 2017 15:40:35 -0700 (PDT)
In-Reply-To: <CAJfpegvqomZq+M6RGBGfj_oHieWL2Hi6L6htsyC4hCmSkh-GOA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, "open list:OVERLAY FILESYSTEM" <linux-unionfs@vger.kernel.org>

On Fri, May 19, 2017 at 4:37 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> Well, even if we go by the route of looking up the overlay dentry, we
> shoudn't be hacking around the permission checks (yeah, overlayfs
> started out doing that, because I didn't know better at the time).
> Instead we can export __lookup_hash() and use that.
>
> But I simply don't know which route is better.  There's a tradeoff
> between memory use and performance, but all depends on usage patterns.
> Probably doesn't matter much, so just choose the one which you feel
> better about.
>

So I chose exporting a new helper to lookup hash.
And now that I also relaxed the samefs constrain from constant st_ino,
I realize that for non-samefs directory, st_ino is the overlay i_ino, which
means that without looking up the overlay dentry of subdirs, there is no
way for st_ino to be consistent with d_ino...

Amir.
