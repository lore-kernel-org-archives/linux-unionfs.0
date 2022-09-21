Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72CDEECAAD8
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Sep 2022 06:51:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbiIUGvY (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 21 Sep 2022 02:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbiIUGu5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Sep 2022 02:50:57 -0400
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5C081B2E
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Sep 2022 23:50:28 -0700 (PDT)
Received: by mail-ua1-x929.google.com with SMTP id e3so1997845uax.4
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Sep 2022 23:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=MnsGQNzEo0345XDijMQ9j4l3TBdfE4wJcl77eG8FkXE=;
        b=XbgB9Tl3hD5P2KlDxipzFCDAvuW1YxTEATT2337Lc+OKldGU0WhTj9AajajnIpTYBV
         2KREg2+yXI65xcI4t4zZUNZi+BqTIKr9oHS8gPdqCNygZ8NAG328ODWIAX/sneIjx/Lw
         ujQFZiPIjMYmZctadKcGDxDrvnOKCo9Q8Wa86y9accZbgi+cWF2hNpWw83nMDJKuygZY
         bKCluakuXhiI/dTadvrKZZcMRukp1AAb+MGO/v34rgkm9RZRM6BA9Kcg70HVsilJLtGR
         Ela24lX8yfLQ9PLPStv0y3Ke9OMP8OueV64q3GKnnW9TAX/DcmhnzftlZZyd3Ttb9+vo
         zO9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=MnsGQNzEo0345XDijMQ9j4l3TBdfE4wJcl77eG8FkXE=;
        b=a7cFcmtQ0PckpCshM/4yJv934jHT8FODgNs8bcIgLgnVhIzti3EznzGr41s4hlLFce
         Y+oksSV4/1ycDa6N3HvIgeNaI73lrgdhbccjEFqatod4OReaESRis22SjwNymP9taUz3
         QJkPICNFKGc1eLkmHYJfBo9VINa09/9hSWI42fefwC6KT3hIg11cyCdvLqa11TIbbQWV
         /5RHncFIIrf48eZ1D+yTD8lzy8fSprNd+91W9VfwOEfwrtj9GTVMByOUa2vyu2xCutlD
         ee7M9mFHanZhBJU6akcLrprD5kPskGaIGUTGQCCh6C4jvZ0W336a5V2LkgX/dpkKnAah
         QbYQ==
X-Gm-Message-State: ACrzQf3s8szdVvAAdd7xMnJqpFqcFuHmba7Gc3R380lq3NgVqMccz/v+
        nPzXkp8qG7fStj0QvTlwZd9dz0aJVVQkrLGx49e1eH2gwOs=
X-Google-Smtp-Source: AMsMyM5gTO/kerTfJkQbcweh7ywKYmT3yzt2pEkeA4tx380TXO4QviCRil2YmKIbWHsKME3c8NhI2LdYwr6zTiz06+o=
X-Received: by 2002:ab0:1c55:0:b0:3b6:3cbe:19ca with SMTP id
 o21-20020ab01c55000000b003b63cbe19camr9583116uaj.114.1663743026985; Tue, 20
 Sep 2022 23:50:26 -0700 (PDT)
MIME-Version: 1.0
References: <6810f0fa-ded3-420d-6978-0faf9667d307@linux.intel.com>
In-Reply-To: <6810f0fa-ded3-420d-6978-0faf9667d307@linux.intel.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 21 Sep 2022 09:50:15 +0300
Message-ID: <CAOQ4uxj1V8EvJuEthaiZK102P8PX4idFmC0BSTuhabPQo6kD0g@mail.gmail.com>
Subject: Re: Does overlay driver work if built in to the kernel?
To:     Keyon Jie <yang.jie@linux.intel.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>, keyon.jie@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Sep 21, 2022 at 3:32 AM Keyon Jie <yang.jie@linux.intel.com> wrote:
>
> Hi all,
>
> I am new to the overlayfs, I am hitting issues to make kernel modules
> work in a container environment where the Kubernetes feature really need
> the overlayfs support.
>
> I figured out to make overlay driver built-in to the VM kernel (and then
> shared to the container), but looks like the Kubernetes always fail when
> trying to create overlayfs mounts, with errors like 'permission denied'.
>

Usually, you want to look at the kernel log to see the reason for failure.
That is likely because the container is "unprivileged"
meaning not using the same uid 0 as the host.

Don't know which kernel you are running, but overlayfs can be mounted
inside unprivileged container since kernel v5.11:

https://lore.kernel.org/linux-fsdevel/20201217142025.GB1236412@miu.piliscsaba.redhat.com/

>
> I am seeing that overlay driver is released with modular
> (CONFIG_OVERLAY_FS=m) in most (not sure if it is all) Linux
> distributions, so I am wondering if the overlay driver work when built
> in to the kernel?
>

It can be built in or module.
That seems unrelated to your problem.

Thanks,
Amir.
