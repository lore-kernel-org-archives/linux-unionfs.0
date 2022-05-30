Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15F95C433F5
	for <linux-unionfs@archiver.kernel.org>; Mon, 30 May 2022 06:22:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232705AbiE3GWZ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 30 May 2022 02:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232742AbiE3GWV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 30 May 2022 02:22:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D90665F43
        for <linux-unionfs@vger.kernel.org>; Sun, 29 May 2022 23:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653891739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uljMwx/pO6gPqUjVZ0QwbqS8WE7db/pDOEER4n8m218=;
        b=VBcRS9DsNSxegwD7Q97pbPXBrMBK1hG8sKp8YrTJsfDF42YvPz1TX6/3JeBsk13lVpE0Js
        CCAbTKBGAYfA02xQM/IAKbJp4CKZro9HtI+8ee4otGOkj9+7Ktn4NTCCLMrRCTnQpLYNrh
        XdUEJeyDYf+krFPhSUJTpuGXD4lFplg=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-654-NFpGzx-ROyiIMUpWn7TmDw-1; Mon, 30 May 2022 02:22:17 -0400
X-MC-Unique: NFpGzx-ROyiIMUpWn7TmDw-1
Received: by mail-qk1-f198.google.com with SMTP id s9-20020ae9f709000000b006a3e88115b7so8067324qkg.20
        for <linux-unionfs@vger.kernel.org>; Sun, 29 May 2022 23:22:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uljMwx/pO6gPqUjVZ0QwbqS8WE7db/pDOEER4n8m218=;
        b=qIPsf40WMQH5AyJBuzfpL/cG5kca7QrCYHMrng8sj/EyzvcH+RK5LjiCDLpzfzB8QO
         D6BbE/jUCuT0NpaW4fpLh07rtMK1pugk3Zrp467oNuorbLqAUs7OdIbtLWBjMugDAw0M
         +NqJpbbsYnjxhjw1pDRT++h2jNmz+emeXXEs8q+Q5w3WZ+J9yEeLrUZHVVWJm1xqnzDQ
         jpCPr/C2K/yFSgU3wY7B8ufq9HHL1W89oL9BCxoAeLzl+Iua1kpI4W0murDNKJ42CMjX
         OWvJ3T+cTU8KvWkVC3vii5QKVb9INKkqbcetsxNuVmQEVtqrpE6WXSDzNboOWCL2MjTn
         TWMQ==
X-Gm-Message-State: AOAM533NMpL0k74rZEmCJC6wUyWPyf0JAJgkm6l491Udml1XY4DB/ySD
        GHE4Yv88WV4XnlUgQhWvqicgvasHvDkYaBOwEsTfNLjn1Cq8NxmgKQpJCgnuiVC9XKWYGcVoh0X
        d7uJfgstvw+MjpYdPBleIKfP1yA==
X-Received: by 2002:ad4:574b:0:b0:464:34f6:57cd with SMTP id q11-20020ad4574b000000b0046434f657cdmr10406624qvx.118.1653891737131;
        Sun, 29 May 2022 23:22:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxh/t8HDwJQIbkOzG1x4qX3AYGsUdrkO2K2iTROIgJbzmCywctQ8vT7IsQdYW9u7ywLaFgkPA==
X-Received: by 2002:ad4:574b:0:b0:464:34f6:57cd with SMTP id q11-20020ad4574b000000b0046434f657cdmr10406612qvx.118.1653891736908;
        Sun, 29 May 2022 23:22:16 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b143-20020ae9eb95000000b006a3457ef710sm7304208qkg.30.2022.05.29.23.22.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 May 2022 23:22:16 -0700 (PDT)
Date:   Mon, 30 May 2022 14:22:10 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Zorro Lang <zlang@kernel.org>, fstests <fstests@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: [PATCH 5/5] generic/623: add overlay into the blacklist
Message-ID: <20220530062210.pwnmnylo6hhs7lej@zlang-mailbox>
References: <20220529105505.667891-1-zlang@kernel.org>
 <20220529105505.667891-6-zlang@kernel.org>
 <CAOQ4uxix_Un2EZUO=7PGMuFgimmKx0QDS_jvkBmgyFQjUgZHrg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxix_Un2EZUO=7PGMuFgimmKx0QDS_jvkBmgyFQjUgZHrg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, May 30, 2022 at 08:54:23AM +0300, Amir Goldstein wrote:
> On Sun, May 29, 2022 at 8:59 PM Zorro Lang <zlang@kernel.org> wrote:
> >
> > The _require_scratch_shutdown can't help this test case, except use
> > _scratch_shutdown or _scratch_shutdown_handle with it. But this test
> > case does 'shutdown' on $SCRATCH_MNT/file directly. It's not suitable
> > for overlay.
> >
> 
> This is not about testing overlayfs.
> It is about testing FS under overlayfs which can detect bugs in FS
> that are otherwise hard to trigger.
> mmap is an especially odd case of overlayfs so I rather not loose this
> test coverage. Please do not apply this patch I will send a fix to the test.

Thanks, if you think it's worth keeping for overlay, I'll drop this patch.

If we change the code as:
  if [ $FSTYP = "overlay" ];then
          file=$OVL_BASE_SCRATCH_MNT/file
  fi

It's actually not testing overlay at all. We might need all testing operations
run on overlay, then shutdown the $OVL_BASE_SCRATCH_MNT. But it looks not simple
to separate the 'shutdown' from the:
  $XFS_IO_PROG -x -c "mmap 0 4k" -c "mwrite 0 4k" -c shutdown -c fsync \
          -c "mwrite 0 4k" $file | _filter_xfs_io

So what's your plan?

Thanks,
Zorro

> 
> Thanks,
> Amir.
> 
> > Signed-off-by: Zorro Lang <zlang@kernel.org>
> > ---
> >  tests/generic/623 | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/tests/generic/623 b/tests/generic/623
> > index ea016d91..1083e796 100755
> > --- a/tests/generic/623
> > +++ b/tests/generic/623
> > @@ -11,7 +11,7 @@ _begin_fstest auto quick shutdown
> >
> >  . ./common/filter
> >
> > -_supported_fs generic
> > +_supported_fs ^overlay
> >  _fixed_by_kernel_commit e4826691cc7e \
> >         "xfs: restore shutdown check in mapped write fault path"
> >
> > --
> > 2.31.1
> >
> 

