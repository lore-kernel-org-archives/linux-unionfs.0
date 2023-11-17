Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9D06C072A2
	for <linux-unionfs@archiver.kernel.org>; Fri, 17 Nov 2023 20:35:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbjKQUfF (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 17 Nov 2023 15:35:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjKQUfE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 17 Nov 2023 15:35:04 -0500
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDBA0E5
        for <linux-unionfs@vger.kernel.org>; Fri, 17 Nov 2023 12:35:00 -0800 (PST)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-5a7b3d33663so26829167b3.3
        for <linux-unionfs@vger.kernel.org>; Fri, 17 Nov 2023 12:35:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1700253300; x=1700858100; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xFsq5ZOY2zHqGNx/GFXBlAAKGEsFhyjxTUZa3++dRDk=;
        b=qy0yIQxGxZ83hhgmWYhqaKRZVy+WWuPQnOm1dodQbgBpmvh3DCbb6ySgWWS/Bq2dvs
         a8+XF1AxQJdAUA09G/n07bDM55Ce0NNtMCVEt3SekxE2HaI806PyAYDjl7Y6OJfnEIa5
         uunq+E6Q5Dm1hwU7HYe2epR9vnTaYersITOE07o/bg/3U60wBOoP9Ej19kofL3EpWOLH
         MgSYhNQe1w1sMMXuC72FmObQq8H4e/GDLUYECPW99o7pDVghqwHuFNA6Sqm24Ie7IMza
         WaFEAvO/UfSLwgyZdljVT6+SBhfqJ7E1RaqqvLYr6XaWI+JkTxXCqnuxmH5BriLb0bpQ
         vkfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700253300; x=1700858100;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xFsq5ZOY2zHqGNx/GFXBlAAKGEsFhyjxTUZa3++dRDk=;
        b=CTGEPKHk2epKDV50QivuF1njzpzYRl5dXcEPSaUN+ptSq4sKlwczSzl8CIJMaBdBpq
         afDBcy1P+aHXQQJphbtYU4je09GhHs5N0sKqcUu4GcvdunnWdkZSXRlIgmTjBTiR891e
         vdq61UcoCFjC91nn8yf1qcyVEo/WAM04C3ZGPtWo3ni6y4XcSdbfugx9v0zLgzBC0Bc8
         i4I3ZTTgCqwcIDJ6Hkuk46BMp+0VCM6t0KDoKsVeL9xxLbi/yziGMXz7X1WJr9LwCL/S
         5TXalp18es0B1TwDCNy1nCRwhLRT9NbDmtOPbjEnFkGRbepJyu6/F92dMJjV5oJ0T7RW
         /cpg==
X-Gm-Message-State: AOJu0YxNDadVxDBuzsMW3gK2xy/BWnuUjiu7JNxIOOuQ0XckUDHGWztE
        lFeDoVtHZiV67NzAyl1/EgAINw==
X-Google-Smtp-Source: AGHT+IGvCDmdWF38qizQS55GByOxRfFU9LmYTxCq3FBYWKPmKmI1xdKVAxPly2j+iu9QVxctmPWsYw==
X-Received: by 2002:a81:c202:0:b0:5a9:30c3:c664 with SMTP id z2-20020a81c202000000b005a930c3c664mr870584ywc.19.1700253300018;
        Fri, 17 Nov 2023 12:35:00 -0800 (PST)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id o4-20020a0de504000000b0058e37788bf7sm685524ywe.72.2023.11.17.12.34.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Nov 2023 12:34:59 -0800 (PST)
Date:   Fri, 17 Nov 2023 15:34:58 -0500
From:   Josef Bacik <josef@toxicpanda.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org
Subject: Re: [PATCH 00/15] Tidy up file permission hooks
Message-ID: <20231117203458.GA1516584@perftesting>
References: <20231114153254.1715969-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231114153254.1715969-1-amir73il@gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Nov 14, 2023 at 05:32:39PM +0200, Amir Goldstein wrote:
> Hi Christian,
> 
> I realize you won't have time to review this week, but wanted to get
> this series out for review for a wider audience soon.
> 
> During my work on fanotify "pre content" events [1], Jan and I noticed
> some inconsistencies in the call sites of security_file_permission()
> hooks inside rw_verify_area() and remap_verify_area().
> 
> The majority of call sites are before file_start_write(), which is how
> we want them to be for fanotify "pre content" events.
> 
> For splice code, there are many duplicate calls to rw_verify_area()
> for the entire range as well as for partial ranges inside iterator.
> 
> This cleanup series, mostly following Jan's suggestions, moves all
> the security_file_permission() hooks before file_start_write() and
> eliminates duplicate permission hook calls in the same call chain.
> 
> The last 3 patches are helpers that I used in fanotify patches to
> assert that permission hooks are called with expected locking scope.
> 
> My hope is to get this work reviewed and staged in the vfs tree
> for the 6.8 cycle, so that I can send Jan fanotify patches for
> "pre content" events based on a stable branch in the vfs tree.
> 
> Thanks,
> Amir.

You can add

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

to patches 1-11.  Thanks,

Josef
