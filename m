Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08A1DC4361B
	for <linux-unionfs@archiver.kernel.org>; Mon, 14 Dec 2020 05:14:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE3F922472
	for <linux-unionfs@archiver.kernel.org>; Mon, 14 Dec 2020 05:14:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730259AbgLNFO0 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 14 Dec 2020 00:14:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726058AbgLNFOP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 14 Dec 2020 00:14:15 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E18E8C0613CF
        for <linux-unionfs@vger.kernel.org>; Sun, 13 Dec 2020 21:13:34 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id q1so14705194ilt.6
        for <linux-unionfs@vger.kernel.org>; Sun, 13 Dec 2020 21:13:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TfHeg40vwwig3KDdlb4QGgSVbJXSbpdN74kDPF7YZCo=;
        b=Siu6HkSG1wuyNdTcpbIC7e8SVAmdzTUud/IBnbBnVft/0r0yyAADr9P0PJAkZ9Tvb+
         Mc1vAo3M8sY1Vv7OTiPK5RyRw9g7HAsskC/ikbqNj2rtKy1UMY99rlcqHksPHWYzNN72
         JdyBOi50ZUYjGGqzhfqE5Si7NO/5/2IPdpRzG009hTEL/GRl2ryhsOrXoWhyTuyoeMPA
         Bzi005vYlPNMLF8wXkRJeMNlynRoaO7QQhByF/XoUnfVZ185/N3X3/XGW+/lTnFfial7
         +dW5/FDnxLUNE4uolgZw3r5BuwAcUAZCwC+O9+8Ft6+OUexMYim+a9VzgBwZdh1w3YEL
         9EWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TfHeg40vwwig3KDdlb4QGgSVbJXSbpdN74kDPF7YZCo=;
        b=JddifFhMlkMOmmcaxXscch8LGI6ayGBZFR5VgCmLuI37bxmWFs3erJvRzP/v51tIWT
         nMQWHLPktFKjkT8HDsnLVQ+1dXqbFfrJFw7Z/3jlOVf7e5+wXFkTU9gUu3vf8n7vEy6z
         DZHAe0g9XP6DZzyfpsAw7srWKS+GXipKHDK2a27Mn//ZYjxgzvCYejjZnNZWz8/vAFJh
         gFaSAutDwa4QiTNTrLkN1Qg/fVKB45tJI6hS1VZW6gj5R/a+QaWgoc6mUDH0RJP2jxy/
         TqaVoRc98Begx5Y4GoE5bw8YNY/XgjKHKhHDJZzILPM/PdVF5YOvm/RBK91u3W4fGW5Q
         kS6w==
X-Gm-Message-State: AOAM531BRZgQiFvmBhjowoSf+uUOX8u8FSVRYS8kz/r1UUXNe0Sj3EJ/
        Qw4t29xSbTzvcicSlm0kNePYdByixhfp6Hnry/XxObnu
X-Google-Smtp-Source: ABdhPJzMzbZj3Wi+5S+8y3JFkmLaGc7/sb30bhrZfIISrRv0SZlq1aq7LEev2NAvAz8ACl7L3xv+nt4To8dUwThlPPo=
X-Received: by 2002:a05:6e02:14ce:: with SMTP id o14mr33335870ilk.9.1607922814387;
 Sun, 13 Dec 2020 21:13:34 -0800 (PST)
MIME-Version: 1.0
References: <20201207163255.564116-1-mszeredi@redhat.com> <20201207163255.564116-7-mszeredi@redhat.com>
 <CAOQ4uxju9wLCq5mqPLgo0anD+n7DLnmHzJ=SymFTRc0c_uVY4Q@mail.gmail.com> <CAJfpegvzU5y09jxpzq=SSKc67bp-03hpqkQa-m4CZk-p2bEcVw@mail.gmail.com>
In-Reply-To: <CAJfpegvzU5y09jxpzq=SSKc67bp-03hpqkQa-m4CZk-p2bEcVw@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 14 Dec 2020 07:13:23 +0200
Message-ID: <CAOQ4uxhFkYiOwCH_UNPC7pO=YELeEkthOAa2WaoiGrys73nJxw@mail.gmail.com>
Subject: Re: [PATCH v2 06/10] ovl: user xattr
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Dec 11, 2020 at 4:55 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Tue, Dec 8, 2020 at 2:14 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Mon, Dec 7, 2020 at 6:37 PM Miklos Szeredi <mszeredi@redhat.com> wrote:
> > >
> > > Optionally allow using "user.overlay." namespace instead of
> > > "trusted.overlay."
> >
> > There are several occurrences of "trusted.overlay" string in code and
> > Documentation, which is fine. But maybe only adjust the comment for
> > testing xattr support:
> >
> >          * Check if upper/work fs supports trusted.overlay.* xattr
>
>
> Updated documentation and comments.

I think you just missed this one comment above that I pointed out.

Thanks,
Amir.
