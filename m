Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1149C433EF
	for <linux-unionfs@archiver.kernel.org>; Thu, 28 Apr 2022 11:35:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243853AbiD1Li7 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 28 Apr 2022 07:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236441AbiD1Li7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 28 Apr 2022 07:38:59 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93507286E7
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Apr 2022 04:35:44 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id gh6so9054512ejb.0
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Apr 2022 04:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5lzeODOu9zOmy7Fs2vznMtFMC4Ve3Tf5iZ/nbesl7rk=;
        b=egU4vvolcLpXN3fZbOCO5FkiD245m2oqRD0aiwDF70lVvE/yzFGZNzDWLb9BHX9p30
         kIkUkKnpYB9xvbbSIjx5Ry6GF/VtVCMyN4wQmsPdsG9lP2zdl6SIrUPkPaNfLZiSxROG
         aVGYF33pDVZ1zgUgD+FDRntB/0Qx2mOBov+Sw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5lzeODOu9zOmy7Fs2vznMtFMC4Ve3Tf5iZ/nbesl7rk=;
        b=GWUcFN3CNUtSdSGs+nTD1B6JBfOeRShNpI6/vi9tgdKwNPLeNxuJ61llPp3X0R56jI
         AA2ocLKsHZCEBPw0Yhp+YTdN2+sWyYanwoyEo9OmMXFNspIK9zAeDCFLqbMS0/h6u2TS
         BL7LWoBzsP5jqeN+/xfvqjTVovOTiRuBpNaGwK+L1Qlyzg3IaaJR0s1NsQySpkTtvXHy
         JUA8JJmU3miz8p6CG1aMJgK9jTz8Q3NdAUY121gRwVCMoo5VOMmb84oIGVXbp/tC0LlP
         JfB2VeiaCS1K0KhrvXXTn9vNEX0k+OWc1mKW2PTTo9T00YNPdquySjK0YjXjisd+88Tw
         eBbw==
X-Gm-Message-State: AOAM531/lRQT3imC4E447iuUOnslPUFCliUVxKPP7ELBFZk9SAKIEjCS
        od/lV2gqm4F1pa2Oqd6r0CwH9WXLN19B70yjc7i66G5gnHUuWw==
X-Google-Smtp-Source: ABdhPJzUVxX3c1TEGWtXqqnIGlgplBap6wKgSALJBHG5CeLeF9g4VviBCdcdyJcBKHgPqEhMEXYRWNYIU7hdb1/mTc0=
X-Received: by 2002:a17:906:2991:b0:6cf:6b24:e92f with SMTP id
 x17-20020a170906299100b006cf6b24e92fmr30932458eje.748.1651145743175; Thu, 28
 Apr 2022 04:35:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220407112157.1775081-1-brauner@kernel.org> <20220407112157.1775081-14-brauner@kernel.org>
 <CAJfpegtXfrgb3qQTvqu6mtunhFjC-FwXcRvqMY4h-ZcjWyhUFg@mail.gmail.com>
 <20220428103046.kizonrkl7h2f2uvc@wittgenstein> <CAJfpeguor9gbfTgaHeZ-RxXoGM6V953vrrksWp9E8cOzc+gLDw@mail.gmail.com>
In-Reply-To: <CAJfpeguor9gbfTgaHeZ-RxXoGM6V953vrrksWp9E8cOzc+gLDw@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 28 Apr 2022 13:35:32 +0200
Message-ID: <CAJfpegtJNVtsBFSH=KDa1CRuWiu1Nywc1AsAJKBJsXFBqrL-Jw@mail.gmail.com>
Subject: Re: [PATCH v5 13/19] ovl: handle idmappings for layer lookup
To:     Christian Brauner <brauner@kernel.org>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Rodrigo Campos Catelin <rodrigo@sdfg.com.ar>,
        Seth Forshee <sforshee@digitalocean.com>,
        Luca Bocassi <luca.boccassi@microsoft.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        =?UTF-8?Q?St=C3=A9phane_Graber?= <stgraber@ubuntu.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, 28 Apr 2022 at 13:30, Miklos Szeredi <miklos@szeredi.hu> wrote:

> So I guess the proper fix would be to introduce a version of
> lookup_one_len() without inode_permission()...

OTOH, we do have CAP_DAC_READ_SEARCH already in the syscall path and
knfsd won't be using mnt_userns, so just passing init_user_ns should
be fine as a quick fix.

I'm in the process of applying these patches, so if there's no
objection, I'll make this change.

Thanks,
Miklos
