Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1E08EE4993
	for <linux-unionfs@archiver.kernel.org>; Tue, 22 Aug 2023 14:20:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236532AbjHVOUy (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 22 Aug 2023 10:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235860AbjHVOUx (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 22 Aug 2023 10:20:53 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFBCECEF
        for <linux-unionfs@vger.kernel.org>; Tue, 22 Aug 2023 07:20:49 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-4fe8c16c1b4so6939892e87.2
        for <linux-unionfs@vger.kernel.org>; Tue, 22 Aug 2023 07:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1692714048; x=1693318848;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Qn9dodwGHzqM4o6Xuadep2wsN/m7oy9fF26H77GOobY=;
        b=gUsPXHuUFrEDZWZntx+8qeFrdwRZKh+TwyBr692HF71IO5nBDiv/DsD4UpWxxGVx8Y
         fKwsHO/RP/t2z0RrS4PCS6GVjm2ek9h4I1Qky7Qyosmjv5ez9ekXsHQN86n5Afn5Byle
         nRXvx8ct5VDH2Af6PNlqvR5ZzAtVntZAaoQjo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692714048; x=1693318848;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qn9dodwGHzqM4o6Xuadep2wsN/m7oy9fF26H77GOobY=;
        b=cPVD5dDTq6Op93jJQrBIuK1gH+57aEnDUfnK+I0U8udq12L79WhCHrCTob7uIR27k6
         n71gShIk1HBC/Yxnb8abhiXzlQSFAVobgFPNbnVQQVPnondWywj0D7mXJf6JM3M5rrBX
         6KluOhARUs+Vj8qYKN7aROuVKeoDN2Zcm5XN7ap3ynhyFgIz2whowI/SWgOhxDu3mWlG
         axX87UntOfNYwGMzBruDjcEeca8wOgVfg4pFnopEhGtsaQPG6Q2gGqB6zOJWCmELhfkW
         +n9iVDkKQQF2vGpkd7C+D5zw9U0Wr563gB2AyPx48wsXwJ0nUsfHLsrONwnVjfTCuW4q
         pbRg==
X-Gm-Message-State: AOJu0YwXqgiX6U+h2Bv78WXk7hZ8kNHAp4tX01hMuSyPnfTGxNEUOxmD
        50y+R/tKQPDV5OjeVVTEA9XTHChURPt/wFmr+Ghg8NFq6KFuesijkqg=
X-Google-Smtp-Source: AGHT+IFasunuJqLhjT7VTKsJGv0OIcCfwYtA72UV5vP4/LAPLzeoCc+WYBLm57t26rnuo7lJD3fl+/M+FHk8xd1Iqio=
X-Received: by 2002:a17:906:7395:b0:9a1:c0e9:58ff with SMTP id
 f21-20020a170906739500b009a1c0e958ffmr990130ejl.11.1692713191104; Tue, 22 Aug
 2023 07:06:31 -0700 (PDT)
MIME-Version: 1.0
References: <20230519125705.598234-1-amir73il@gmail.com> <20230519125705.598234-6-amir73il@gmail.com>
 <CAJfpeguhmZbjP3JLqtUy0AdWaHOkAPWeP827BBWwRFEAUgnUcQ@mail.gmail.com>
 <CAOQ4uxhYZqe0-r9knvdW_BWNvfeKapiwReTv4FWr_Px+CB+ENw@mail.gmail.com>
 <CAOQ4uxhBeFSV7TFuWXBgJZuu-eJBjKcsshDdxCz-fie0MqwVcw@mail.gmail.com>
 <CAOQ4uxirdrsaHPyctxRgSMxb2mBHJCJqB12Eof02CnouExKgzQ@mail.gmail.com>
 <CAJfpegth3TASZKvc_HrhGLOAFSGiAriiqO6iCN2OzT2bu62aDA@mail.gmail.com> <CAOQ4uxjU5D=BmLe66NyG_qGWk8rhZGKx+BCZmJQmhQOdCSw+1g@mail.gmail.com>
In-Reply-To: <CAOQ4uxjU5D=BmLe66NyG_qGWk8rhZGKx+BCZmJQmhQOdCSw+1g@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 22 Aug 2023 16:06:19 +0200
Message-ID: <CAJfpegu8QQZJVYz6bku_x-ai4YhJ+RBXLJzdq9+FyTo6dGtkCA@mail.gmail.com>
Subject: Re: [PATCH v13 05/10] fuse: Handle asynchronous read and write in passthrough
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Daniel Rosenberg <drosen@google.com>,
        Paul Lawrence <paullawrence@google.com>,
        Alessio Balsini <balsini@android.com>,
        fuse-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, 22 Aug 2023 at 15:22, Amir Goldstein <amir73il@gmail.com> wrote:

> IDK, ovl_copyattr() looks like a textbook example of a race
> if not protected by something because it reads a bunch of stuff
> from realinode and then writes a bunch of stuff to inode.

Yeah, you are right.

> Anyway, I guess it wouldn't hurt to wrap it with inode_lock()
> in the ovl completion callback.

Okay.

Thanks,
Miklos
