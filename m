Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A466C433F5
	for <linux-unionfs@archiver.kernel.org>; Thu, 28 Apr 2022 14:39:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345616AbiD1Om7 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 28 Apr 2022 10:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345455AbiD1Om7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 28 Apr 2022 10:42:59 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02854515BF
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Apr 2022 07:39:40 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id gh6so10087352ejb.0
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Apr 2022 07:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eA4wV/j/rXwB1OPZtA9i2a/mh56NLOlK2URWVo2Zr4g=;
        b=gRXPzX6R9m3NgVdiVnAaAOHnfYBvmj8KJdDJv6AUcO+LRKqLzw+2QKz+q/vBrtsGNu
         Q09H7tbcfxwpvT5s1AHPlcD0GIwS5g818/G145IBObiIscXvbMq9Ht7bwdDDDUQ/JQ0y
         u+NiDl9RJ2AQfe1BHHsfs3U6nJJNC/amzb5tE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eA4wV/j/rXwB1OPZtA9i2a/mh56NLOlK2URWVo2Zr4g=;
        b=XVVsnrvQbJ2ILgqY7K8fAajZXkwaP5ID6gKB2fKjmm3DUYT/5h1c7cC88iH/63eu55
         c1WRpi3Gbbw7mST6eaBO5gAGF1lP3nVTHHh+jni22Ukz6N/Jyv1z/qGNaW5WZbDxIlHa
         //gEXjwg2OCvV+f9S+JulU/BvPrUR0erdDpVpbaDYd7T4kDgJyOJITZjv5jMzXfiMGzm
         kXppwIQQvEfFPCFVjVXYatLeI3KrG6QL9jSTayZEiHiwvJcNQa0UWD7UMVeMQCE+3WHR
         QAgWCkxQnqCI1DhrG4J6RoubmAueuIRs1Y8MLsunPWBaDyNdzJ8jL5ewdUorH/zrXUEU
         9/OQ==
X-Gm-Message-State: AOAM533mLzCQDZkPAaQPnhTb9l1CDkEnn5WZNNI/lRfHkAkKUJDHrv1L
        5reNW9pPpR2aCKc2i0WQlwbzR0DVVuJKIsM7bXErhQ==
X-Google-Smtp-Source: ABdhPJxd7ueXjRDyMjTBBCSF+d/w5F/+L6p0Sz8sX5UZQZ2QbiVZnt8P1kWlcUZQDfpHOULY2nhC+Pa7ZsREQ8COsVw=
X-Received: by 2002:a17:906:8982:b0:6f3:95f4:4adf with SMTP id
 gg2-20020a170906898200b006f395f44adfmr20044187ejc.524.1651156778612; Thu, 28
 Apr 2022 07:39:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220407112157.1775081-1-brauner@kernel.org>
In-Reply-To: <20220407112157.1775081-1-brauner@kernel.org>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 28 Apr 2022 16:39:27 +0200
Message-ID: <CAJfpegvFNpruOPCXp-HfgMgw5n1Mj5bj7J0JMeAXeMa=587CsA@mail.gmail.com>
Subject: Re: [PATCH v5 00/19] overlay: support idmapped layers
To:     Christian Brauner <brauner@kernel.org>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Rodrigo Campos Catelin <rodrigo@sdfg.com.ar>,
        Seth Forshee <sforshee@digitalocean.com>,
        Luca Bocassi <luca.boccassi@microsoft.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        =?UTF-8?Q?St=C3=A9phane_Graber?= <stgraber@ubuntu.com>,
        Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, 7 Apr 2022 at 13:22, Christian Brauner <brauner@kernel.org> wrote:
>
> From: "Christian Brauner (Microsoft)" <brauner@kernel.org>
>
> Hey,
>
> This adds support for mounting overlay on top of idmapped layers.

Pushed updated series to:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git#ovl-idmap

It's mostly just cleanups.  Survives quick xfstests, but please also
test that I haven't broken the new functionality.

Thanks,
Miklos
