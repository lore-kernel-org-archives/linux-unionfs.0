Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F224C43217
	for <linux-unionfs@archiver.kernel.org>; Thu, 24 Nov 2022 13:03:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiKXNDY (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 24 Nov 2022 08:03:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiKXNDX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 24 Nov 2022 08:03:23 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C20342AC5D
        for <linux-unionfs@vger.kernel.org>; Thu, 24 Nov 2022 05:03:22 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id vv4so4063527ejc.2
        for <linux-unionfs@vger.kernel.org>; Thu, 24 Nov 2022 05:03:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CXYjrEeqBjoEZp5atThlO1xUvZiu3dT5u3aKCEaJMEc=;
        b=cyc29IYj7Deq6koejGBwgRUcnb+If87+B0Zu7Hl1WrDMAG/4cQpUf27x45pe8qekg+
         ItpFc0i8LTicTfEb7TR4kX42EVQdEwQwr+sdD34TgEwMZwFkvHliuRL75oX/anttCjKO
         ctoDLTg0q1/UtMWPYoB8ONR8u0XFbVnMrc7RI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CXYjrEeqBjoEZp5atThlO1xUvZiu3dT5u3aKCEaJMEc=;
        b=AJXq3f4y71GuwH5yQXHiaRk6U48knj3XAtqF3XBEcwlfOBr5xyV67j7Jz5OwqUqbd2
         lDL9bNQL7evXUp9xXnwcqYQNe/O/PYxod3AdVR/AgAcMphXol5OEQdXYfzl2j2AAuNid
         W9TFwoM441iExNKYdKe3Yq+ycmHSgaP9aL5AGobzhQOvFRX29inPqw6e3pomGRfsPHFf
         P83G2EW3jz6nhggf2e/i1KugbT1zroV3/H0ETXYFaft9kiy3n/9TMqEs3ICdu/2/J1OZ
         SedApLIw+N/jH9oNbEuFQggRjCsYNvWzAcmn385Nx7hmGGrcd2TaJ6SFTS0mNgMBAs1m
         g3Xw==
X-Gm-Message-State: ANoB5pkSiztOmV7OQB+fs1iQ6lwLxdpaycKUjzXktTvSThSi94XFnLew
        XTfJsdYQTM8qqQ2CSqXV/IL/lXG+XS4apjTD+5RWdA==
X-Google-Smtp-Source: AA0mqf6z9LXsbx/DeTFaMuLETxiKT4zMlPDRPChHW2y8ky/D4eqL+AWLHIL1obyxqAJLLZkg52XHEEw0ZnYIYSU528s=
X-Received: by 2002:a17:906:99c8:b0:7b5:ff35:6715 with SMTP id
 s8-20020a17090699c800b007b5ff356715mr10558287ejn.255.1669295001360; Thu, 24
 Nov 2022 05:03:21 -0800 (PST)
MIME-Version: 1.0
References: <20221120034143.684416-1-o451686892@gmail.com>
In-Reply-To: <20221120034143.684416-1-o451686892@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 24 Nov 2022 14:03:10 +0100
Message-ID: <CAJfpegs6Upm6NcbO9GAJ88Vn_WDmCqs2C71tiRr9BfJEhR+7OQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: check IOCB_APPEND flag
To:     Weizhao Ouyang <o451686892@gmail.com>
Cc:     linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, 20 Nov 2022 at 04:42, Weizhao Ouyang <o451686892@gmail.com> wrote:
>
> Add *_APPEND flag for ovl_iocb_to_rwf().

Why?

Thanks,
Miklos
