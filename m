Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7B75CE7AF9
	for <linux-unionfs@archiver.kernel.org>; Thu, 28 Sep 2023 05:11:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbjI1FLh (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 28 Sep 2023 01:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjI1FLg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 28 Sep 2023 01:11:36 -0400
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3238F
        for <linux-unionfs@vger.kernel.org>; Wed, 27 Sep 2023 22:11:33 -0700 (PDT)
Received: by mail-ua1-x931.google.com with SMTP id a1e0cc1a2514c-76d846a4b85so4637837241.1
        for <linux-unionfs@vger.kernel.org>; Wed, 27 Sep 2023 22:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695877892; x=1696482692; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LLN5rUvcVJMOjRlrX3rs6fEf9eH0mLudrqu7JTfxE6M=;
        b=CqkvSFyVtFaVezKKKwZ6qxiwILEi9aW9ZWPEc2J9J1snEdxeUTA8Kw6p7BzZBVXT1x
         z91d8AW36eD0U4qtLcNPYhrqz4hZpx0z6RHtEjRidVE9hw574HBViyEO2KwU3s3c2bKw
         QqAX+h0A9nheOfxui+PAXJjLolSfr2vS3Kjkxm/iX4Z8/qRaFai5rDmi+Efl51yvIMCd
         kAIayPejTTd43BqtbtX/ybX3HVcBCkmAg1I9TFiXjPqW0fl0cyJRbK0cMgVT7mHVaJkY
         mPZxmw7Sy/29WyvGOUYV1yaClkvD+qCjVstPYR3DLkMhOyWbbsj+XNhU3uTEERtrAEWH
         OmSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695877892; x=1696482692;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LLN5rUvcVJMOjRlrX3rs6fEf9eH0mLudrqu7JTfxE6M=;
        b=dXzLY175LvdNhhXfQbcGRH7XqgSYj+M+xtvKEihQSpiZgorMmNahDjATYh4x5o9mPD
         h+npQpRi4px9Od5rc6PMdwTfdBdAw7vPq1itdipDWH8DUd5ytGE2Xv5GKctp7BloRoW0
         rU5VzioIElmqRrrAAFIvUC/anOyjC7jjk+DrB7i52lrlgF2nmo3H2+tajWxin6gnFib7
         au43ufr1mXkJGhosGpUQ2zRcI2ETrsbdmntpV2SO8xALaVLT2tc6AWy8P1wa83WRMBKL
         a0OAdqt0dKGfSIzfy6g304N9GtCgSVvUWbyII1+eWsNTSE0Z66RV3+J/xYW89YOn4lDn
         AlrA==
X-Gm-Message-State: AOJu0Yx3El62TlvBn+y03Nv/LDQJmhUzVMRAgHkllZdpbjUOIPUmefnn
        GQGo5voQPVblepuIDo1HHdbJa7WKKJkZHIopRm5triTJ
X-Google-Smtp-Source: AGHT+IGlUE7pXI0R6n20q+GbDZ56Ib0BjRNhpJAy2xMlrAlqC82nwC7Ok2qILhINPChbmEf46ao1/tMo5CZspv3U7lc=
X-Received: by 2002:a67:f403:0:b0:452:5d45:6345 with SMTP id
 p3-20020a67f403000000b004525d456345mr136681vsn.34.1695877892314; Wed, 27 Sep
 2023 22:11:32 -0700 (PDT)
MIME-Version: 1.0
References: <20230912173653.3317828-1-amir73il@gmail.com> <20230912173653.3317828-5-amir73il@gmail.com>
In-Reply-To: <20230912173653.3317828-5-amir73il@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 28 Sep 2023 08:11:21 +0300
Message-ID: <CAOQ4uxh7RFs339Jx4-2z+pOohdc8SFKbiE3ocRJVSzdvhVOagQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] ovl: move ovl_file_accessed() to aio completion
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Sep 12, 2023 at 8:37=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> Refactor the io completion helpers to handlers with clear hierarchy:
> - ovl_aio_rw_complete() is called on completion of submitted aio
>  `- ovl_aio_cleanup() is called after any aio submission attempt
>   `- ovl_rw_complete() is called after any io attempt
>
> Move ovl_copyattr() and ovl_file_accessed() to the common helper
> ovl_rw_complete(), so that they are called after aio completion.
>
> Note that moving ovl_file_accessed() changes touch_atime() therein to
> be called with mounter credentials in the sync read case.
>
> It does not seem to matter with which credentials touch_atime() is called=
.
> If it did matter, we would have needed to override to mounter credentials
> in ovl_update_time() which calls touch_atime() on upper dentry.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

This commit is nonsense. It does not fix any bugs.
Direct aio also calls file_accessed() before submission,
regardless of overlayfs.

And on top of that, this commit has a bug that regresses sync io.
So I am dropping it from overlayfs-next.

Thanks,
Amir.
