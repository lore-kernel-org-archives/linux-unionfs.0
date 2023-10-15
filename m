Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D37AFCDB47E
	for <linux-unionfs@archiver.kernel.org>; Sun, 15 Oct 2023 20:40:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjJOUkQ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 15 Oct 2023 16:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbjJOUkQ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 15 Oct 2023 16:40:16 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBB8EC1;
        Sun, 15 Oct 2023 13:40:14 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id 6a1803df08f44-65b162328edso23195586d6.2;
        Sun, 15 Oct 2023 13:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697402414; x=1698007214; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uDOyC8Wnk0Ty3C9d0j5CGeA8uvd6m5WGiy0iJAxr4yo=;
        b=hcQ7mz/ugGyELWeynE5Eofed1NbCs4xca9p33I552hfP7jyYHyxo+7LqA1rBhjEJv8
         314SAL/B9ehfRrHrrpenP/+h+npz+o7hVWjtbCsFnYlL4/cdsy1pIFK4WvUakYCr9EpC
         P+YPw80kWOUMFG8dW40jDsXAB/K/IH6VDL6SLvoTbNhr4MM2sYd/6NHxfXmDVd8VAizr
         SrxMXvFsLbJelq9L1oD9aYE3+j86FnnwLx0E04IRKJFYNb78NeahF7WfHOYaiqJJojC9
         vjASEmrNlbbRuTKsotDNj4Tq4CU2/NnPYEpXLIO4CONoegnq7cdzOhzF5o0aEhc3HVx5
         OWLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697402414; x=1698007214;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uDOyC8Wnk0Ty3C9d0j5CGeA8uvd6m5WGiy0iJAxr4yo=;
        b=Ovk9XkkbY6csG0/8YVxWdnuU+XCTks4h+2CuTvhwbr7z+l0hAWaEetSqmNuoGX8ZaF
         gtRbSjCZjraLAR8V3TgwFYQ9uv4NLzQUz+C5iW22UIYFZc1NHbDYwjQoy8p3onOvOiqe
         YlHPZmOHs7qmKc1MYp1+BjspgyLd9SI2fv89aodgnCr4U+nBqCYuxKfmgueVloH1xBP1
         ah6Kr6Y2ia6cdp/t2ndLqQ7DHUCKkjWeljXqEO1kBci8AYI5rt0Nqxlp5dEaWP9zIv+/
         zJcpfdI7YvPVbVuYfNqcAp4qwZ3R5+qsnE6HrPdwdkvRaAW8aIwR1fRqI0mLob8Hms1v
         mKrg==
X-Gm-Message-State: AOJu0YzR1A9NG47aC5/kFHRkWuu1t/otiP6Choi5L52oZBrQjpalu5EV
        WjCNaRVaEhS4f0nzAbVWOW392yZ08C6CjlO7sJ0=
X-Google-Smtp-Source: AGHT+IEBdfFloVh9XG7n7EQtgVxEQP/NlgX7+cn7FRgkxG8kpT/1SW+d+e/wHZKZ/X2fNnSQw50k8Z7w57BCh/CRuM8=
X-Received: by 2002:a05:6214:19c3:b0:66d:46ac:2fbe with SMTP id
 j3-20020a05621419c300b0066d46ac2fbemr4260122qvc.16.1697402413976; Sun, 15 Oct
 2023 13:40:13 -0700 (PDT)
MIME-Version: 1.0
References: <2023101542-semisweet-rogue-1c44@gregkh>
In-Reply-To: <2023101542-semisweet-rogue-1c44@gregkh>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 15 Oct 2023 23:40:03 +0300
Message-ID: <CAOQ4uxitMY+h0r4rKDF0enMGcbrcOHeu+pDCid40mzXAKMD9eA@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] ovl: fix regression in parsing of mount
 options with escaped" failed to apply to 6.5-stable tree
To:     gregkh@linuxfoundation.org
Cc:     ryan.hendrickson@alum.mit.edu, stable@vger.kernel.org,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Oct 15, 2023 at 9:36=E2=80=AFPM <gregkh@linuxfoundation.org> wrote:
>
>
> The patch below does not apply to the 6.5-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>
> To reproduce the conflict and resubmit, you may use the following command=
s:
>
> git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.gi=
t/ linux-6.5.y
> git checkout FETCH_HEAD
> git cherry-pick -x c34706acf40b43dd31f67c92c5a95d39666a1eb3
> # <resolve conflicts, build, test, etc.>
> git commit -s
> git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023101542-=
semisweet-rogue-1c44@gregkh' --subject-prefix 'PATCH 6.5.y' HEAD^..
>
> Possible dependencies:
>
>

Please apply this dependency (from 6.6-rc5):

a535116d8033 ("ovl: make use of ->layers safe in rcu pathwalk")

Thanks,
Amir.
