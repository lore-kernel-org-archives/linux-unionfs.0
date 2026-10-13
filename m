Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5C51E5018
	for <linux-unionfs@vger.kernel.org>; Tue, 13 Oct 2026 13:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791897346; cv=pass; b=Nkt9gwGPgFP7SDmDTJ1BKx/oIcR20WUZi+GXgfCzv1PD5tJXHIiGmU0tYwRNDKnabHhg4SQoX/Y9tp/nP7GSs8NCdgwPNQETLbH5B3cU3cj4Ngm6x8OVpApw4ooguBci3YLHxDgcpawrZkuL91vQY8FshT2vIsNKXeeHTS2/sUE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791897346; c=relaxed/simple;
	bh=2WgoFCrTZBovUPfg7MKYavwIIHiaFcOX7H6qxDnrgfw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=pI/6DXxYep8SdlDuC5LHLFJ4S1mwZx1U28HR9Hd6kCloU3O0NbIBxop59hcCr/6T8uzCiYncu1ryHfr8LiM0SW+g5f7fonYHB9oJqg3NIsLnU1/j2VsCPrkSAX1g251EkRGn/zVy7KcMDfau6AEPf7hGmy51YX40MkY+I0/hRCU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=studiomoob.com; spf=pass smtp.mailfrom=studiomoob.com; dkim=pass (2048-bit key) header.d=studiomoob-com.20251104.gappssmtp.com header.i=@studiomoob-com.20251104.gappssmtp.com header.b=ohMo28/i; arc=pass smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=studiomoob.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=studiomoob.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=studiomoob-com.20251104.gappssmtp.com header.i=@studiomoob-com.20251104.gappssmtp.com header.b="ohMo28/i"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-93e706a6ba9so396472685a.2
        for <linux-unionfs@vger.kernel.org>; Tue, 13 Oct 2026 06:15:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791897344; cv=none;
        d=google.com; s=arc-20260327;
        b=TkSihTxU3OVYW4WJcKUFsmEcGQ1s2t2ujPwyjKaNov63HRrZLfU1qvnEJ6EIQ1inT9
         4UkbElj9I8d4IhZpsrGFA1r0RnsmRTYFVmfMzNAaGZ/6YsNHsf8SKlY2tvOEqxPoX5KL
         qsbj0VnZihSYepL8H3wwi3jJ82j1vkdT7TNBPY5PilDdwicl9+2kQNwK2/PiXRDAGYzH
         uyzy726eth20vL/atkMplFzoSwBslGnh8cuWgPRlcoTglFmqEHI8a44RDw/PPc6uCf5Q
         F7imSXGv/LyG40KpNrcH506wffRg770wEz2ISLhcoDuclwF743zWkD5rOhW0ATdHAoOS
         i21g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=FenRfiIMzpIlkyhlascNicg46YraY0kY/SgnXziFJxI=;
        fh=d5SG8nr0Uv54tZrTs5Dymqa+MsPZ62tDlKU6sBNPjAA=;
        b=GRd3khcUh7jlV5FIBueuvDR3mdfQaIlYunU01c3srKlf/yWHG4E84A9RG22X5C6XAp
         UlztqJo/kL5j5qxgbNeSMy5VspIGjVy6VQv1mP+/MSDh+AAqYRWKpN0xy/7nP7XTV3a0
         4A+cq0032dD/k5dG8A9fAAtv9+e2wuAnjV8XYKKAQJ9mW/xQMV+lfkQ0G1zwmCmZmRtx
         FJCyy6CiMfUb6n28mFbXIAgoDTlV9zrno9H94LfkjewTT5MKgTrfLj/ZDUMZtFysqRjh
         RlqcEpVokak4v83TdNzROjIIADYT785j97+eKO5ShAUYEhtUfbbL6lVxowDjOMeA5ODb
         nTdg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=studiomoob-com.20251104.gappssmtp.com; s=20251104; t=1791897344; x=1792502144; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=FenRfiIMzpIlkyhlascNicg46YraY0kY/SgnXziFJxI=;
        b=ohMo28/iFcwVVIMcn5LrjXyHWVe8FU16C43UEjtkwTuWxeoZZ1VC89IdKJeJBI9qN7
         CvaxzFT6qZBEcgRnJW5b5SE2TqBVvwTO0axd61w30GETIBUAoBmIASvgT8576A+0uNfT
         OAE1Zp7OxTDFz0IK7Ph/VIrpWbMDYUROYjMPDprJAViX0Nzy6au4/oSPncR2wRf3Boun
         ai0GUFS2TJHckJrcNEr84CfIM2IHPf/tb3inOmLCxR6+meWZoJmqsG4oKwcg3llkC4QX
         g/ayjHrKl1KM+kZPLLp3TBL5R7Q/aH61ea8/nx8l95AQ9e8Z5PkCmn9NYQyx++clLtBL
         c9+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791897344; x=1792502144;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FenRfiIMzpIlkyhlascNicg46YraY0kY/SgnXziFJxI=;
        b=TE+/GlGZLKAWS/EMuQ5RBdx/lsO0hAiqOcAOJ0bZjptqvIUwvqRnEvfEXTTGxOLBW/
         0Xr4Gg9OojmWeVRWSbJOl1/txB0QPqfZfdVm3/dF44nKUGhlsVSKyWzAhb+KykHjo8E1
         gsQVQm+NBKR1buELw+S75XJW/g8+Rshvg1/v0JiUyVMrDGzuF1YCuhvnNfk6mMTxT4p3
         +24o8h0uVnxR450ruua5FCEP3F1oOlq53o8N5QwkLDm5TlxE6TjBYmsCJTgimS8t9N1K
         Wgnc0pLvQbPa9v/IJFn8/PhxyQDSWmz90OqPG5AQVJ6fh5PjVPjq9vykB6ZKM153+NAf
         X2MQ==
X-Gm-Message-State: AFq9FYLn6916NvZrK9AgTOOE7MkI8KaGTZkhJNgaGCLZDafIfIiX8GWg
	VB7SJPyGyaj/LDCmwY1YdRmD+MlIXo7sKIGEnifHqIUUQ/10hGhwx2XYV0uOBgg0IILaOP6op2O
	bUQeeBZy1m3TnJXKiwK8F1ZlZeumsFHwOLKqoGscluckQJa6RlTohWaQ=
X-Gm-Gg: AYBFou01UgZhnNTrwOQWtXciGwvaDcwsYodni0AeLTEsYWcinkeZhJ8hp37yLM8IeyW
	ecu95zcpQ7j4dyiL6Icb6q+vmr5yuPq48ZgH9be3Ng60B9IPrhz+8BxMsw/EuukpNE08ekIOldA
	0VOiabiMp1nKAolLtfvqGzlxROaU3IZVE6eZfP708+Mjb2YtCwj8TYmKS9GImZQeNVzXGqdyPTj
	kmO5MUAHuZ8WRXFK1JHSyiPEMsGZi8AVfiilB1SK67JN3jYpC5oA+NAqQT+VGmq6w+chgo4Is2U
	KhXhLzq3QE/cnY7c6SXRNBTWi+98QlpGLQQPRxnFYaGgzyDmF2ZWhp0p8DfkvmPDNelpG4bD/Uv
	PpxLML8YSizh8
X-Received: by 2002:a05:620a:4503:b0:939:de48:e41f with SMTP id
 af79cd13be357-93ebd248c42mr1952455685a.31.1791897344108; Tue, 13 Oct 2026
 06:15:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: =?UTF-8?Q?Cl=C3=A1udio_Fernando_Pinto?= <claudio@studiomoob.com>
Date: Tue, 13 Oct 2026 10:15:31 -0300
X-Gm-Features: AclHuK94LrerG-pya9Rwa1_D3nFtKKEuzQo62CfrYep04hQTEGiFZkoMiYkmIVc
Message-ID: <CACU5Mh9eozKjrTdsLq1bzsO8Ceg9rtBXoS7YUyCkieZq1JRESw@mail.gmail.com>
Subject: [RFC] Stacked fs, mounter creds: caller checks in the lower fs
To: linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

I maintain MoobFS, an out-of-tree, experimental GPL-2.0 stacked
filesystem for 6.12. It is not proposed for merging and this is not
a patch. It was developed with AI coding assistants; I review and
test the result, and nothing in it has been externally audited.

It follows the overlayfs credential model: name operations run with
the caller's credentials, data operations on an open file with the
mounter's.

This week fstests showed that our copy_file_range and clone paths
called the lower as the mounter without file_remove_privs first.
The lower clears set-user-ID bits and file capabilities only for a
caller without CAP_FSETID, and the mounter has it, so they survived.
overlayfs calls file_remove_privs at that point; we now do too.

Question: besides the cases below, is there another decision that a
lower filesystem takes from the caller's capabilities or ownership
during a data operation, which a stacked filesystem must take itself
before switching to the mounter's credentials?

Already checked, against the 6.12.112 source:

- file_remove_privs before write, splice, fallocate, copy, clone;
- CAP_SYS_RESOURCE dropped from the mounter's credentials;
- dedupe: allow_file_dedupe runs on our files with the caller;
- removal of security.capability (cap_inode_removexattr);
- open: may_open on our inode, permission asked of the lower inode
  with the caller's credentials;
- only S_SYNC, S_NOATIME, S_APPEND, S_IMMUTABLE copied to our inode.

Not checked: any LSM policy. SELinux was never loaded in a test.

Repository: https://github.com/studiomoob/llmoobfs
  layer/main.c
  docs/decisions/0011-threat-and-credential-model.md
  docs/history/0074-privileges-kept-on-copy.md
  docs/history/0079-credential-review-file-flags.md (the table)

Tests run in a VM, and under KASAN, UBSAN and lockdep on 6.12.112.

The code changes every week; the issue names the commit to read:
https://github.com/studiomoob/llmoobfs/issues/16

A pointer to a commit or thread is as useful as an answer.

Thank you,
Claudio
