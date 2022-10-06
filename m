Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74F0AC4332F
	for <linux-unionfs@archiver.kernel.org>; Thu,  6 Oct 2022 13:03:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiJFNDj (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 6 Oct 2022 09:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbiJFNDg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 6 Oct 2022 09:03:36 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 867739C7C8
        for <linux-unionfs@vger.kernel.org>; Thu,  6 Oct 2022 06:03:35 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id ot12so4472120ejb.1
        for <linux-unionfs@vger.kernel.org>; Thu, 06 Oct 2022 06:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=bJE4vQ3mtcOL5hiYWRkbYO1oVGrXpLNRDbNovHGW6kw=;
        b=l6f/A42Fq6jUpz/665ggFaN0o95U6gH0t1HjIiewfaSsZyUXtBfs4tZKvKZ3hpXylH
         jgTgOPGDhCddwgZh53fLmofo/oG+qOeOjKkScieGJ1fY6lA85nkwsRFRZOH1AT9bEbkb
         Yq+XfUSq/N4wAqNnM/C25kNyjg0WgjQXqgN3U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=bJE4vQ3mtcOL5hiYWRkbYO1oVGrXpLNRDbNovHGW6kw=;
        b=M7XoY43y2OYLT+/wIjL2HlGyISqPj5p+BondO4n7EA91Jclb034jdJLCXYCoqvoWDj
         dBbvAhBtKwF7bJtqOfX5D0MTpoIdfTgvDqKEVUCTwhqcR3ZSIRpr9O5AweV24I6hJ8EC
         VP2anOWM8AcSzsuoGb832I2QTh/PeBZo0czL7ojj7N4ZV+DHD5Hng2QZmmSa6MRYj9zg
         BUCTAJNbvu8xG8vEhzO4erka7S/Qso4mZQA1hXwZq1sU1oGHAFJ7pNlZsOrVyHmzIOtF
         nzRqmbXE/YuwqThqx6TNeHM817pdqn2S0efBBCutaeOwwDxTq6aPjsIQO7wIedqddMos
         qK+w==
X-Gm-Message-State: ACrzQf1gb2sEwFJKqfovN08SMUMNxz5CZh3nlKjdu+L6l6WuOpZjAwr/
        uj2juKCIeHBpIIhJh/T0waOHuzgaoswHIxmrUeGfhg==
X-Google-Smtp-Source: AMsMyM6wtdTmULcErYXHSyqyGbj0ebfq7U1sGvuSMxBzEbpnt6UwWuQPcpXpLvcGfTlDwzlH0aaQ+6pFH1Vftw1qs3U=
X-Received: by 2002:a17:907:a0c6:b0:787:8250:f90e with SMTP id
 hw6-20020a170907a0c600b007878250f90emr3910387ejc.8.1665061414138; Thu, 06 Oct
 2022 06:03:34 -0700 (PDT)
MIME-Version: 1.0
References: <20221005151433.898175-1-brauner@kernel.org> <20221005151433.898175-2-brauner@kernel.org>
In-Reply-To: <20221005151433.898175-2-brauner@kernel.org>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 6 Oct 2022 15:03:23 +0200
Message-ID: <CAJfpegss=79W+BXpOH_n7ZOtci1O0njHHxZMnb8ULJBStkq7mg@mail.gmail.com>
Subject: Re: [PATCH 1/3] attr: use consistent sgid stripping checks
To:     Christian Brauner <brauner@kernel.org>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        Seth Forshee <sforshee@kernel.org>,
        Yang Xu <xuyang2018.jy@fujitsu.com>,
        Filipe Manana <fdmanana@kernel.org>,
        linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, 5 Oct 2022 at 17:14, Christian Brauner <brauner@kernel.org> wrote:
>
> Currently setgid stripping in file_remove_privs()'s should_remove_suid()
> helper is inconsistent with other parts of the vfs. Specifically, it only
> raises ATTR_KILL_SGID if the inode is S_ISGID and S_IXGRP but not if the
> inode isn't in the caller's groups and the caller isn't privileged over the
> inode although we require this already in setattr_prepare() and
> setattr_copy() and so all filesystem implement this requirement implicitly
> because they have to use setattr_{prepare,copy}() anyway.

Could the actual code (not just the logic) be shared between
should_remove_sgid() and setattr_copy()?

Maybe add another helper, or reformulate should_remove_sgid() so that
it can be used for both purposes.

Thanks,
Miklos
