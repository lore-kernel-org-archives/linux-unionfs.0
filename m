Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98743E748F1
	for <linux-unionfs@archiver.kernel.org>; Sun,  1 Oct 2023 00:41:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232815AbjJAAl1 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 30 Sep 2023 20:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234147AbjJAAl0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 30 Sep 2023 20:41:26 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B00CA;
        Sat, 30 Sep 2023 17:41:24 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-534659061afso10955872a12.3;
        Sat, 30 Sep 2023 17:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696120883; x=1696725683; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yTSxipMp7nuYeyKZGAg23gsTHntqNXxrwRwfb9UBZ6w=;
        b=dj/pHXwH+iMC3V8EOVcPda0dxCWoXHpABXMnVGXBKIojWKeDQkwMarDoCrYhHBzr9g
         3c7LJ+dtkxKQN6O1rVab7C8Re8/IITKanrrDMeM7uTyrHxwTRcUtDPb3gsB8/4by7m9W
         u2zHq5Wc7Q4HROs7EFeG218qg0lE9B0+snOwN/SH2dsYVVE9a7EtZ2UigqdG3U2gSak5
         qDeBdAWh6SHqZXwAPDxnCiQ73dY5LuiKvXOIc1MNXSfc6fUFjOvPUNFiahf/Zgss6wKQ
         x99mECK8bWdRJmYzb6K5zba2VSAyY0mr8HwrmnVP8HarBvCe+SYF4H/FUI0t86f5YF1N
         GPAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696120883; x=1696725683;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yTSxipMp7nuYeyKZGAg23gsTHntqNXxrwRwfb9UBZ6w=;
        b=cB3QLcPAqjQVn3E3Iz0+EcEVvJjEUcsQ40cRLUvbt6uZGGoqiIZxYpQkFOMq3CIZ6l
         2tLF68sMnn9BTG0cXOCMi++tbt/swiCXZ/A2AvzU6T9NApSQsVN85htdHFf49xRzA9HX
         /LeQz2hvGrs4tDK7gs9YtVG+IXAriN/qT8Vd51O7Y6EfzX6ZtmS/v5NKnAQ4tIkB61wZ
         A2ElmdO+PeTSoshqDP3dnyP8YDMlOwXqBXgsAgHC9dFCkPuxqSbAnYKyOG5+Oo6ya0tf
         4KEthf41XcxvqN2G8p8QjUrKFpV7SF4cfxAiB9/4p0mB+9NL8b+M2b+BhmTXFqx2WX6P
         MXFg==
X-Gm-Message-State: AOJu0Yz+ubT37eqIw+4Vx2hyjGYEXWpQYYgov+AH0Wu+1pA5Icg5jL5o
        rs63KwT/VBFqXgXySD8qmPY=
X-Google-Smtp-Source: AGHT+IGRM4elz777JUk9F74f56ES4Nr9BRY5JrkFyH3MhaFE7ZtGkTHM1o9oGOaDbZRXZ2z5Sg4trw==
X-Received: by 2002:a17:907:774d:b0:9ad:f87c:57a8 with SMTP id kx13-20020a170907774d00b009adf87c57a8mr6715673ejc.3.1696120882736;
        Sat, 30 Sep 2023 17:41:22 -0700 (PDT)
Received: from [10.134.50.150] ([89.249.73.142])
        by smtp.gmail.com with ESMTPSA id l13-20020a170906a40d00b009875a6d28b0sm14645377ejz.51.2023.09.30.17.41.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Sep 2023 17:41:21 -0700 (PDT)
Message-ID: <9e57cce1-2eca-411d-98a4-3321823d8f3d@gmail.com>
Date:   Sun, 1 Oct 2023 02:41:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] README: Update overlayfs URL
Content-Language: en-US
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     fstests@vger.kernel.org, Zorro Lang <zlang@kernel.org>,
        linux-unionfs@vger.kernel.org
References: <20230928202834.47640-1-uvv.mail@gmail.com>
 <CAOQ4uxhx59ZnMbhLTL85M1VQta6AZ2oqe9gMQJcN1qiAzOu6tQ@mail.gmail.com>
From:   Vyacheslav Yurkov <uvv.mail@gmail.com>
In-Reply-To: <CAOQ4uxhx59ZnMbhLTL85M1VQta6AZ2oqe9gMQJcN1qiAzOu6tQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On 29.09.2023 05:16, Amir Goldstein wrote:
> On Thu, Sep 28, 2023 at 11:30 PM Vyacheslav Yurkov <uvv.mail@gmail.com> wrote:
>> Overlayfs-tools and overlayfs-progs projects have been merged together.
>>
> Nice :)
>
> Do you also have any plans to improve the tools?

Thanks for the review!
I'll move the instructions completely to README.overlay in V2 then. Is 
there a particular reason that the file starts from an empty line? 
(perhaps I could remove that as well in the same patch)

Right now the plan was only to maintain both projects and accept patches 
from others. Perhaps I will also update the build system to something 
up-to-date. As for further development, unfortunately I don't have a 
project behind ATM to improve the tools further. If something pops up 
(or you have something), I could try to find a capacity for that.

Thanks,
Vyacheslav
