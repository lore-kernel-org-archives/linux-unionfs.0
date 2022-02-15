Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E32E4C433EF
	for <linux-unionfs@archiver.kernel.org>; Tue, 15 Feb 2022 09:21:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233521AbiBOJVm (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 15 Feb 2022 04:21:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbiBOJVl (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 15 Feb 2022 04:21:41 -0500
Received: from mail-vk1-xa2b.google.com (mail-vk1-xa2b.google.com [IPv6:2607:f8b0:4864:20::a2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A7F113DFB
        for <linux-unionfs@vger.kernel.org>; Tue, 15 Feb 2022 01:21:31 -0800 (PST)
Received: by mail-vk1-xa2b.google.com with SMTP id t19so9192461vkl.0
        for <linux-unionfs@vger.kernel.org>; Tue, 15 Feb 2022 01:21:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lY8wcTj5YvSO2HVFkQBrQ7MLdA39XjEqnGlo8r6RlrE=;
        b=SbqCruFvLdnJqn4Imsi0QxlRUEUz6wlNhsmG9uI0Alt+7JRRRD7deeJEQpS0khmrJa
         Kod0DkDKa0gVKtE4/Jj7ylofgOrw92d3S3CeTMXDxzVKRkeDQu4idTQ9SrS/AM/XDMF+
         8/YvOMS/VeBneD1hyfjumrmCa2GtCngVR3T1k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lY8wcTj5YvSO2HVFkQBrQ7MLdA39XjEqnGlo8r6RlrE=;
        b=e6xUNinjWB/NZIYuQZ2bXShzQfxw0/Mvb28Fu2lMT7PKsClK7G0cPkIPTDx6/35vR1
         GiHZhbB8nxjc7ZDOJQt+SlCYPyOIjagBE0XvJUOJAfuOGD+m77uT/lDks6/kVrpOioaC
         zwTEbTuDbDBoHGsgWllHB5pl4itzq/Eq/dQCKyA+xUraBHVVCu1brxcpF/FS0wYUxH8/
         kW8t6EP/hIp68X5U4oR6ogNQ1OM1F9EiK5H9scCac+RYlKjGrhdXWxLher/CQuMIgeMg
         7Fi7EWu1w+ISiYC/5bnYwQk1+3/tMzi4Qi3vgslGoqnBb1e6CqMZEtdE/pJvOZMXLO1q
         rOGQ==
X-Gm-Message-State: AOAM532TxWTBmX0NIdmP43cBzNDViekTHy3p+gs4HUzEeXFRw6Fao+U3
        CmLjiEy8i951WI7xzVIlD6B8aAz3ogRTDydB89oOOh93CnE=
X-Google-Smtp-Source: ABdhPJwSdeJ4IgXX2nk/a3tQoBCimNNe6GnyQ04Tdm/SdzcO/ByLZbahHCoqJhWBfZUAFKdSfjoziMLAkrI0y8Rd7Ok=
X-Received: by 2002:a1f:908d:: with SMTP id s135mr1106577vkd.1.1644916890295;
 Tue, 15 Feb 2022 01:21:30 -0800 (PST)
MIME-Version: 1.0
References: <20220211030055.95334-1-hongnan.li@linux.alibaba.com>
In-Reply-To: <20220211030055.95334-1-hongnan.li@linux.alibaba.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 15 Feb 2022 10:21:19 +0100
Message-ID: <CAJfpegvmgUi_XQn6xVovyG1h6RqkqzLrDf5w61yj7F01dN13gw@mail.gmail.com>
Subject: Re: [PATCH] fs/overlayfs: fix comments mentioning i_mutex
To:     Hongnan Li <hongnan.li@linux.alibaba.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, 11 Feb 2022 at 04:00, Hongnan Li <hongnan.li@linux.alibaba.com> wrote:
>
> From: hongnanli <hongnan.li@linux.alibaba.com>
>
> inode->i_mutex has been replaced with inode->i_rwsem long ago. Fix
> comments still mentioning i_mutex.

IMO "inode lock" is more descriptive.

Thanks,
Miklos
