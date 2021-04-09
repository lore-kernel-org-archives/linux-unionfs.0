Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5078C433B4
	for <linux-unionfs@archiver.kernel.org>; Fri,  9 Apr 2021 09:12:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53C9E610D0
	for <linux-unionfs@archiver.kernel.org>; Fri,  9 Apr 2021 09:12:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232795AbhDIJMb (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 9 Apr 2021 05:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231954AbhDIJMa (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 9 Apr 2021 05:12:30 -0400
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD8F8C061760
        for <linux-unionfs@vger.kernel.org>; Fri,  9 Apr 2021 02:12:17 -0700 (PDT)
Received: by mail-vs1-xe2e.google.com with SMTP id e16so2013613vsu.0
        for <linux-unionfs@vger.kernel.org>; Fri, 09 Apr 2021 02:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u0mM1iEeAkRPLRCZ4erKpfLa9yurXLNOFnDZhkMXDIA=;
        b=NOReFmc7K6iCsAx7JdWRFhDZkwH+mdCPd1I91bwxEy4S79ZVhZaNmuTx9Q5DYtY9V6
         O63n2d7NvG0Ydhxwfw7kb/tKDNMGarTGqZ9GadSAO5tz+1l51KIUunV7TErAXUHSCNdP
         s/vcc+OedK2nLJRL/VWpgklj9XLmEiCquPvEc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u0mM1iEeAkRPLRCZ4erKpfLa9yurXLNOFnDZhkMXDIA=;
        b=hxyh8ITN5XWJpKZ5sL3VRDCyKDHDLXfN8aSNgLyTfcjY1gNg7j4eFYMnuUsXRaE0Ya
         3XkCXJ+bQV5hSIIjZAwsmgQfUtNquiMQgqzEiRP88b+WKeATsKk+RgCJHjR2KOFqfn6T
         RraStRwBx6cLld8IFp6JUBwLoLGbqyATY3eBewTfoad75xtoj5gRnH8iAWcFR/wjTCA+
         LfJp5tN8wHm4Z0JsGNfLB0IuMhT3oVWVUypmQUXv/7RdfeSCN3wFn8dGRdCxK69j53n+
         fXXTfeD31n1fIja45Gr/fQ7Ho4OSMU4LpCick/ZiWwte2tf6XKGwS6nIkkQT8FVo4xBD
         xuVg==
X-Gm-Message-State: AOAM533EE6XR22/V2onSgBtL0c4ZdUKmhtX2r/XEWE0dPwJF2uvJi0jN
        ZuGF4N/lMzVx7ikDFa5URmT3213Cf1DLCG960XnJcw==
X-Google-Smtp-Source: ABdhPJwDYQUwmykUqsCuWr0RT5OIr6b2sOxTKDYfHM3J/0dygcpdMhksfRbIj+dXwFnOmNEkTEipFIPjIiGsFTbVe+o=
X-Received: by 2002:a67:f487:: with SMTP id o7mr10292422vsn.7.1617959537129;
 Fri, 09 Apr 2021 02:12:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210304164515.3735726-1-gscrivan@redhat.com>
In-Reply-To: <20210304164515.3735726-1-gscrivan@redhat.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 9 Apr 2021 11:12:06 +0200
Message-ID: <CAJfpegt58xXuB7hu5T7PY00ix3Tcqxk2HZc8EMbyJrj9R-TxEw@mail.gmail.com>
Subject: Re: [PATCH] overlay: show "userxattr" in the mount data
To:     Giuseppe Scrivano <gscrivan@redhat.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Mar 4, 2021 at 5:45 PM Giuseppe Scrivano <gscrivan@redhat.com> wrote:
>
> Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>

Thanks, applied.

Miklos
