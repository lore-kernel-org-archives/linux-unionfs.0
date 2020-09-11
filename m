Return-Path: <SRS0=kt3Y=CU=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 001B2C433E2
	for <linux-unionfs@archiver.kernel.org>; Fri, 11 Sep 2020 02:27:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B389E2078D
	for <linux-unionfs@archiver.kernel.org>; Fri, 11 Sep 2020 02:27:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l+fKGVqw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725355AbgIKC1a (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 10 Sep 2020 22:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbgIKC1Y (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 10 Sep 2020 22:27:24 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E7F3C061573;
        Thu, 10 Sep 2020 19:27:24 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id g128so9419727iof.11;
        Thu, 10 Sep 2020 19:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ux1GKKyrONJOhwhWD6nhJU/dB/RXXJ31hFVy+2EHZyc=;
        b=l+fKGVqwTc6l6ugGzosyni9oKAPVl9UZz8eZkgtjGvAalxO9aYQxhXPVb4PX5OGMLw
         Phxh2BlzEaBjMJQYdbf0JyRDaFXLro5Vw+tPLFR2ZHW2yAg+Zhx0eoYgJp7nlVtZH4+S
         VvQFO8bX1x12d7I6R7nRrqw3ssrqS8j3xF5/KPpnPhftbPKMQHKKeIZwlEn9HZLu6cJa
         nTfMcOo3WedE07JH55tAaj/11gqjVHDPnjrC7Q4lPjcFxnmtCJV958OYb4Ov+m4paHKg
         20APH96c7TlGk9n3jhf8aUFaZzBOSqUZPLE7QlceCMPLjAi2WCJiTfJC1h9fHkwLb5VK
         3bAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ux1GKKyrONJOhwhWD6nhJU/dB/RXXJ31hFVy+2EHZyc=;
        b=uih0bph3AkDXINVZ9XCejiDkTJ9eDzVAVP87HbDaONxfXSWeOiwKtccCJEeofWXdoQ
         /etcwPWZGGLtgxA6CKFuzxEiZhhJnwVwk35KpGdaXHWQSiaLWhi2rAnBtIrUyAt/n1lZ
         gOeecXanMsz+2RTUtOMVGovP54cK44C3TiBUUei7ryb7fCYSO3xQU3AvF7ch5cWehY5M
         dchIeNBPH120510uHMmD3Ko7YtM052iKXrNyim/2zIweQ4//JummrNmJRIpG5jfIC8vz
         msMAu6NcwUWOkU5FsChkMhVDIYPOv1yLe7kCBOnr7V7xHeAeCsaxeFsgZhb8oVhP/aTw
         Gi8Q==
X-Gm-Message-State: AOAM533FY0+hBadVqwhgzQxUa3wk0CDvULST00sP3/JGx02ttYDB+wvO
        9+RQ4BMNLh/Cg3MkngOEPUeBFYUjWEYidiU28U4=
X-Google-Smtp-Source: ABdhPJyBwgknh3qslnJhE0LAQxrg8auZoHU8vIfsVUoZ/UnozwbDLqg/pTO1emAcDB9Wbb7OqIPiRlvM9D7wmbneg+k=
X-Received: by 2002:a05:6602:240c:: with SMTP id s12mr49109ioa.5.1599791243661;
 Thu, 10 Sep 2020 19:27:23 -0700 (PDT)
MIME-Version: 1.0
References: <CAOQ4uxh+ppPMOSeAZU3sdwxwb_ixMHEpHLF9ZO_MTiedNJRgsw@mail.gmail.com>
 <20200911021813.o6vtueabupevfgab@xzhoux.usersys.redhat.com>
In-Reply-To: <20200911021813.o6vtueabupevfgab@xzhoux.usersys.redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 11 Sep 2020 05:27:12 +0300
Message-ID: <CAOQ4uxhd8Sn54iWRiPAgPnOXqt=PaPuQchrVzeARhgUCVzASgA@mail.gmail.com>
Subject: Re: [PATCH v2] overlay/073: test with nfs_export being off
To:     Murphy Zhou <jencce.kernel@gmail.com>
Cc:     fstests <fstests@vger.kernel.org>,
        Chengguang Xu <cgxu519@mykernel.net>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Sep 11, 2020 at 5:18 AM Murphy Zhou <jencce.kernel@gmail.com> wrote:
>
> When nfs_export is enabled, the link count of upper dir
> objects are more then the expected number in this testcase.
> Because extra index entries are linked to upper inodes.
>
> Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  tests/overlay/073 | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/tests/overlay/073 b/tests/overlay/073
> index 37860c92..c5deccc6 100755
> --- a/tests/overlay/073
> +++ b/tests/overlay/073
> @@ -99,7 +99,9 @@ run_test_case()
>  {
>         _scratch_mkfs
>         make_lower_files ${1}
> -       _scratch_mount -o "index=on"
> +       # There will be extra hard links with nfs_export enabled which
> +       # is expected. Turn it off explicitly to avoid the false alarm.
> +       _scratch_mount -o "index=on,nfs_export=off"
>         make_whiteout_files
>         check_whiteout_files ${1} ${2}
>         _scratch_unmount
> --
> 2.20.1
>
