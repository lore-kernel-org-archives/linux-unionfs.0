Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48728C433FE
	for <linux-unionfs@archiver.kernel.org>; Thu,  6 Oct 2022 12:58:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbiJFM6T (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 6 Oct 2022 08:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231791AbiJFM6D (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 6 Oct 2022 08:58:03 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213EEDF7E
        for <linux-unionfs@vger.kernel.org>; Thu,  6 Oct 2022 05:57:27 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id bq9so2602147wrb.4
        for <linux-unionfs@vger.kernel.org>; Thu, 06 Oct 2022 05:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=lWPeU58iRjRyoDqwaFtxQGqfl9KnL32cM4cRmo8vYs4=;
        b=T+zTF1Tl5sDJwMTkiMCxkdQT8khtIFd/7B7mhXM6ZtZiuT+zRWCODove36KmJtU9rC
         TKb+TmBDlSZDHn/48XLKotY0Sgq81mN3DIlZq/jxem97KPpW/0WJ/1bThUMpfN11CrL7
         Y8dIEUAeX8BPl4L+XiX+m2LXfzZBDInq7RPYs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=lWPeU58iRjRyoDqwaFtxQGqfl9KnL32cM4cRmo8vYs4=;
        b=Sq2SyUWPD2btVahgFkp6JEsd9XFrkbidijd4DkENVCfA5fAAeaZX4LG1JDTmLojEBH
         h/lxjf6SPvbkW8jvh8eUvPshRcpIN1U441WJ9dk+CTEcuyUgTlZvBDw3+XmNBDw6Rar3
         jBE16nbNfGhjHMnoBn0NngwviEKYYNQbFZqEUMuK6DfXY4M/O4nCECTJF2SoQVnvhP0k
         AO3aCvqSo08NAuPmhv1z139LJ+sUVoMO/dM8ew2mGoNDNMtHp0KiQBDal60k00N2icKU
         ub612ZUlWj1mHQr9h91JX1zC4QVYUzWIj278e+UjU3SW5BEfnTlWnB3AWziH+PcSz/Gm
         76Iw==
X-Gm-Message-State: ACrzQf1KJKZ/r7UVCITY6c01p9gtLe6uACDAuUsdahZ3OWA4IdAlSCnF
        wceFN6ouNlirP2Nm3F3IM85+SgvATUVJwVKKMbZyMkox9YI8rQ==
X-Google-Smtp-Source: AMsMyM6j4TxIuyGrnoFijdlbKg7HT/nBqquZCHrQTmJmn0BEpysVBCEKSx/VbZt8FZ/qviUZukTtcd+y8QcDHJIw674=
X-Received: by 2002:a17:906:4fd1:b0:787:434f:d755 with SMTP id
 i17-20020a1709064fd100b00787434fd755mr3774303ejw.356.1665060616356; Thu, 06
 Oct 2022 05:50:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220929153041.500115-1-brauner@kernel.org> <20220929153041.500115-24-brauner@kernel.org>
In-Reply-To: <20220929153041.500115-24-brauner@kernel.org>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 6 Oct 2022 14:50:05 +0200
Message-ID: <CAJfpegu3_pDK2HTrwJ=ehBkBXYdTjF_DFd=oVF9M-k887sKkrA@mail.gmail.com>
Subject: Re: [PATCH v4 23/30] ovl: use posix acl api
To:     Christian Brauner <brauner@kernel.org>
Cc:     linux-fsdevel@vger.kernel.org, Seth Forshee <sforshee@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, 29 Sept 2022 at 17:31, Christian Brauner <brauner@kernel.org> wrote:
>
> Now that posix acls have a proper api us it to copy them.
>
> All filesystems that can serve as lower or upper layers for overlayfs
> have gained support for the new posix acl api in previous patches.
> So switch all internal overlayfs codepaths for copying posix acls to the
> new posix acl api.
>
> Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>

Acked-by: Miklos Szeredi <mszeredi@redhat.com>

Thanks,
Miklos
