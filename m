Return-Path: <SRS0=+UIx=6F=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9AD5C54FC9
	for <linux-unionfs@archiver.kernel.org>; Tue, 21 Apr 2020 18:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DAB22054F
	for <linux-unionfs@archiver.kernel.org>; Tue, 21 Apr 2020 18:59:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="oPs+/MAO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbgDUS7i (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 21 Apr 2020 14:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725870AbgDUS7h (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 21 Apr 2020 14:59:37 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5CE9C0610D5
        for <linux-unionfs@vger.kernel.org>; Tue, 21 Apr 2020 11:59:36 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id s10so11028247edy.9
        for <linux-unionfs@vger.kernel.org>; Tue, 21 Apr 2020 11:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6XNOPZ0rbF7Hz0NMnViVjTMNZwMM/nd35+iGWAdIv0s=;
        b=oPs+/MAOznjSdbFYxKXdE0V+5woz3deW32Njkh/FdM1R4zh5Am9Sn5TFRVEr2F95NS
         ZKbqjj9gw8A2wi45W+bgkYpML+LKiohIicfvFHfG5yf3xHMz1jvQnbnZJg+I4BJQWOs+
         UlVZHP4/l9jjwreClEcNOiKMt4FPobtQMDQPA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6XNOPZ0rbF7Hz0NMnViVjTMNZwMM/nd35+iGWAdIv0s=;
        b=G4rfir19aXvMlv+kLRnNDzo2xSV91Ri7pu+Djcwxve0ujOrwPFSN+7xQs73o/6bybK
         G+8n084EZbhBWsCYPRTm3dx6yj3ZjG74ve9WbIKb4pyT9wCQ4QTEtCrg8CGIBmxl4ZDL
         ZjXhCoMADAC6HXmCi2WEli1SGSoRgN6SroQa+DSA6kDmvaV5ucVD7lwni6ykMUhyzpt4
         ZlahwmVquX1T15Zh+734l9nUlt+lpBFdaL+gE9K60WFY19Ue55+k2YAsRubot9QmOcPR
         CNlFz5CCcmURhxmeszG8WCozsTaTruQzSmPoMPC2ZUiTLTKYD7HbZrBpqTSiFldyPkH5
         jbrA==
X-Gm-Message-State: AGi0PuYmr0OD4bROvzIcw8tRVeHnNRps21k4On6uvuf6RiMgoec6xdWo
        inciMGYos38cjM22YV9BC2QLg9eEhzkLrLrBSC0lpg==
X-Google-Smtp-Source: APiQypKUpf5FbgsfoTtQ7nM1hgPqY5fRa3lXxaI6RuJm0Ou/j3eo4uV+YcdoFATsPtJwWDu/HyY+QNo8dTYeknvz+vc=
X-Received: by 2002:a05:6402:286:: with SMTP id l6mr12118698edv.134.1587495575605;
 Tue, 21 Apr 2020 11:59:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200421184107.GC28740@redhat.com>
In-Reply-To: <20200421184107.GC28740@redhat.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 21 Apr 2020 20:59:24 +0200
Message-ID: <CAJfpeguGqLxA14unqNx-nExCWKs1Tv_0MwqGohHnuW-ugcjDyQ@mail.gmail.com>
Subject: Re: [PATCH] overlayfs: Pass O_TRUNC flag to underlying filesystem
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        virtio-fs-list <virtio-fs@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Apr 21, 2020 at 8:41 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> As of now during open(), we don't pass bunch of flags to underlying
> filesystem. O_TRUNC is one of these. Normally this is not a problem as VFS
> calls ->setattr() with zero size and underlying filesystem sets file size
> to 0.
>
> But when overlayfs is running on top of virtiofs, it has an optimization
> where it does not send setattr request to server if dectects that
> truncation is part of open(O_TRUNC). It assumes that server already zeroed
> file size as part of open(O_TRUNC).
>
> fuse_do_setattr() {
>         if (attr->ia_valid & ATTR_OPEN) {
>                 /*
>                  * No need to send request to userspace, since actual
>                  * truncation has already been done by OPEN.  But still
>                  * need to truncate page cache.
>                  */
>         }
> }
>
> IOW, fuse expects O_TRUNC to be passed to it as part of open flags.
>
> But currently overlayfs does not pass O_TRUNC to underlying filesystem
> hence fuse/virtiofs breaks. Setup overlayfs on top of virtiofs and
> following does not zero the file size of a file is either upper only
> or has already been copied up.
>
> fd = open(foo.txt, O_TRUNC | O_WRONLY);
>
> Fix it by passing O_TRUNC to underlying filesystem.


Or clear ATTR_OPEN in ovl_setattr()

Need to think about side effects of passing O_TRUNC down to underlying
fs.   Clearing ATTR_OPEN seems obviously safe, so as a quick fix I'd
rather go with that for now.

Thanks,
Miklos
