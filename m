Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02030C6FA82
	for <linux-unionfs@archiver.kernel.org>; Fri, 23 Sep 2022 15:58:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbiIWP6k (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 23 Sep 2022 11:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232820AbiIWP6M (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 23 Sep 2022 11:58:12 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8654314C073
        for <linux-unionfs@vger.kernel.org>; Fri, 23 Sep 2022 08:57:17 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id z97so801557ede.8
        for <linux-unionfs@vger.kernel.org>; Fri, 23 Sep 2022 08:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=DzpGNY6qRpjvL6rdAdxNnBtFSX5iFVFNjOYVjQX2mgU=;
        b=K+d5LWQ+mcpwMdjkKl38wLHWsgtW/pfgGpFdWPQyS6gQw2ay+rGO9pJyBsVaLApAQX
         moPiPW6mPKkmUdD9Y/laPZfk1imjCkXBh6AGj4o7EQBdGTm3kLkpYKmrMCVHD4DVeVCU
         qyJzE4XAdR0iWiBjrtv5dxvA3Q0VJdV88cxog=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=DzpGNY6qRpjvL6rdAdxNnBtFSX5iFVFNjOYVjQX2mgU=;
        b=OWA4i2rcfLgc0u5xX46ND4w9nCmt+WHiZos6byYkIpvQKQ8g9e75Xw58ORk+v+mdEZ
         Elg9frmDM4aQYbRknMq/OIf2jQ2CK6nkY/5iJRFOHOWlNzaAmkFOmHbNOOBxIV6/oXbY
         k6HYNEGd5Ka3+QWcfOKjVsmrqTNTpD73rg/VNpnKRVxnlRylrTX2R0wKwa5Ln1RMGysm
         f/u1GUnIGPVrOH8xqMLD7s4U5hOIKIvn0y72scZyHt8Ps/Q8OslEO2qkTJPDHB+yHpah
         UbV4/MwwBE5g/n/Ve+ypMaEpsxm+C0x95ogl83jAs5DBZxV2uwZak3PEM7agNyCLvjia
         fJVQ==
X-Gm-Message-State: ACrzQf3DROuyE65MRHtCNtfnPJkG6g+UQbXe77tkUc4daBosJ+yZK7wX
        VjNcjvi5VpbUdZ396gMFN+LOeDwNw5mBz6cARy/hvA==
X-Google-Smtp-Source: AMsMyM4AfYGL+uZVCifeXudVUOpUqiNvccD2kXCTHEo86/tx34f/XJVjf6vxdpHJSPWfvhDH2qW9u5IDgV2eo8kSX0g=
X-Received: by 2002:a05:6402:4517:b0:443:7fe1:2d60 with SMTP id
 ez23-20020a056402451700b004437fe12d60mr9214209edb.133.1663948635811; Fri, 23
 Sep 2022 08:57:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220922151728.1557914-1-brauner@kernel.org> <20220922151728.1557914-24-brauner@kernel.org>
 <CAJfpegs092_0VkmfnyRP54_fJrssQbDxsh2Q754GLq34LZb0LQ@mail.gmail.com> <20220923154742.iplvc4nj5y6gaci4@wittgenstein>
In-Reply-To: <20220923154742.iplvc4nj5y6gaci4@wittgenstein>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 23 Sep 2022 17:57:04 +0200
Message-ID: <CAJfpegt1YJzyE=UYF=DNW-qd08zLRgG7vpbm32m0rWEbWjLNOw@mail.gmail.com>
Subject: Re: [PATCH 23/29] ovl: use posix acl api
To:     Christian Brauner <brauner@kernel.org>
Cc:     linux-fsdevel@vger.kernel.org, Seth Forshee <sforshee@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, 23 Sept 2022 at 17:47, Christian Brauner <brauner@kernel.org> wrote:
>
> On Fri, Sep 23, 2022 at 05:38:34PM +0200, Miklos Szeredi wrote:

> It's basically just like when you copy a file betweed idmapped mounts:
>
> mount -o X-mount.idmap=<mapping1> --bind /source /source-idmapped
> mount -o X-mount.idmap=<mapping2> --bind /target /target-idmapped
>
> cp /source-idmapped/file1 /target-idmapped
>
> where you need to take the source and target idmappings into account.
>
> So basically like what ovl_set_attr() is doing just for acls. But I

But then before this patch the copy-up behavior was incorrect, right?

In that case this needs to be advertised as a bug fix, rather than a cleanup.

Thanks,
Miklos
