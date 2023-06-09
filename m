Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A995FC7EE25
	for <linux-unionfs@archiver.kernel.org>; Fri,  9 Jun 2023 08:22:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240718AbjFIIWc (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 9 Jun 2023 04:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239282AbjFIIWP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 9 Jun 2023 04:22:15 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE1E46BA
        for <linux-unionfs@vger.kernel.org>; Fri,  9 Jun 2023 01:21:03 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id 4fb4d7f45d1cf-514924ca903so2297031a12.2
        for <linux-unionfs@vger.kernel.org>; Fri, 09 Jun 2023 01:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1686298798; x=1688890798;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4IFWYyf7AHG1YK6ToLFBS30KicQHW59OkJcHs5Sk//c=;
        b=A8RUIjrd7LmeCMRHnqHgqqjgdgPoagNoNArGO0MDbg7Tf614h9aPRc23QosJA9hpVC
         GYa3KdWhogLLyNcs2QNFy82IcFJ6AP11GMhdr2Q8funxOgpJc2YlDiR5FMFJ5FTgiBQE
         nhD/TYn3wvrHRpxyxBPqIrGby/4WTp4Fi2VYk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686298798; x=1688890798;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4IFWYyf7AHG1YK6ToLFBS30KicQHW59OkJcHs5Sk//c=;
        b=RcrHiRNWurHnOh8xx/Y/D7rn9NjSlDo7hLHxlwql2wkJ9Menr29v2EyPEWeSr1quuy
         XQRD6/40T0iguvGFTl102IRl9HmvMuL8G/CTOzfTd0+mjhFsqErA/qICyKit073fPDob
         OzGiXV8YB5qqTJRhVKPx9/2KDP3v+hEoT2G4dx4/K6omKR8brpvhbF3J6nfvddk5O9ro
         bdMcq62gOAoM65F+Jt7S+qpiqBZkv99+BACKFpvS0t2F+W9NyW6spPpf+XIyaiYai6A7
         wCkzVfxLGQREF0ELfBCIKyxyh8ba/ILAtRzOQuanAeer3HQdlXb4pVHSOBvnaITqy+pH
         BJQw==
X-Gm-Message-State: AC+VfDxvs8GKSFKP4GHQ64wpQUNu+TnLAesYE7H15HZv0AK2UJk2d7O3
        Q+WCKO05g7ShQIPb/7fCQz7vnd8Q7DExs/45KfGlCw==
X-Google-Smtp-Source: ACHHUZ4C2Z8z76TpsaSC5hnjHwoW+WWNnwFyAbHiRGfqvFJs/D5EQBrqmaNY7ZftDRtFoMuU0ynnRRVsVb2mlWsY6uY=
X-Received: by 2002:a17:907:6e1a:b0:974:5d6e:7941 with SMTP id
 sd26-20020a1709076e1a00b009745d6e7941mr969070ejc.6.1686298797776; Fri, 09 Jun
 2023 01:19:57 -0700 (PDT)
MIME-Version: 1.0
References: <20230609073239.957184-1-amir73il@gmail.com> <20230609073239.957184-3-amir73il@gmail.com>
In-Reply-To: <20230609073239.957184-3-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 9 Jun 2023 10:19:46 +0200
Message-ID: <CAJfpegtJ0BHB6k0uK3=175LfL5iTnghxucr3j3sGxoCcm=+a4Q@mail.gmail.com>
Subject: Re: [PATCH 2/3] fs: use file_fake_path() to get path of mapped files
 for display
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Christian Brauner <brauner@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Paul Moore <paul@paul-moore.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, 9 Jun 2023 at 09:32, Amir Goldstein <amir73il@gmail.com> wrote:
>
> /proc/$pid/maps and /proc/$pid/exe contain display paths of mapped file.
> audot and tomoyo also log the display path of the mapped exec file.

/proc/PID/exe is based on task->mm->exe_file.  AFAICS this will be the
overlay file not the realfile, so it shouldn't need any special
treatment.

Same for tomoyo.

Maybe I'm missing something?

Thanks,
Miklos
