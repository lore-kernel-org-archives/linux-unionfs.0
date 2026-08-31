Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0CF55C306
	for <linux-unionfs@vger.kernel.org>; Mon, 31 Aug 2026 13:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184037; cv=pass; b=r9T5OR7xI3VoblKi7mH3R+A6YkO5qou7F/54sbpiIn0H9brVilB/CJTn6VNxEiuGEq2rzEnkBSk+P2lbWoALm6fAQsvVzrAhU/8rgS39NqEJWqhNkUGcFBm3kdwTwnvFq8/NqLLy48hHTrdyILCAlYEO0RtKv5Szs8peoDciYGE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184037; c=relaxed/simple;
	bh=sJI2mOCc7tznZH1xeE6WUqxrzQLAatMXruEgFfzLUks=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qSemYAbHf6PpLov/O1d0SNFLCk2o3mhw5vI9LuGPP04o5JlALb9osOc1L3AKsDfbTiARNsClyrixAqPUaP3ZkLRzff+NnKzUZ8EW5m7eELcOf82yz1f0l33oew6bAdOIYbkVOjofrR3m5maifZkx1UVwnOf9nh6+Pt2HpRSvEPo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lRp5bbzk; arc=pass smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lRp5bbzk"
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-46af2e2654cso102741fac.2
        for <linux-unionfs@vger.kernel.org>; Mon, 31 Aug 2026 06:47:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788184034; cv=none;
        d=google.com; s=arc-20260327;
        b=UXMA7Pgt6b8X8hesrdzB5YANMeXOoC2sa4xb8eaTwH+Nf5ky4t5EBkAvAgjGpfjF4g
         /BS7GV8T2KbRw/jxPYsZQzlWslNm8WiCPsEZtK3ieO3vNu9LD9FKy23mEr+6go8fswUq
         J+/gc0SWCkeWvep3ZTZYGTNRz9EedA0rQGOCjA8r7WYKahWoV6oIvpazUWX3jWRuj7A/
         bekPgtw2e7WPuMdOJpkttuaAdAmsJlAoE6coNJAiiOyI56HGEEA1W9tCf7IGm7w7qBj0
         kF7RqBfEWU5B6nr7l1razPGojQ9O9HkbHajh3BKmXsYjKvJm7gaVSRE8AhZNXuVawjFK
         TqdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZXdZhCAXl/YPLluX+b217oaIUS3C82lBDYKPatd622s=;
        fh=3EYOZdwbPvcwbbKQ/KtgZEDww+lJclO9OtOM4gFFUf8=;
        b=Jz10TQHNHlQ8sWf573PCDuQPMZ4ozT3pnFxl4qiYkfRAyjfv+zGH1qq1JPaDhfZ2LO
         GPk3QBIRQoT3znOYh4fpXZX76bkE/MtZIQvp4hczVick9N/bC+vSX6iplSNyTzCm47Gy
         A/t5DDHZLWmhI56Lw+jsKWjPlgEFMOqZpCWt2dH2j/9b8P9gpjwu3mDyTd8WhzzhFcMA
         9e5yBAWFc1DN4OgDg7y273+75j1P4kN+ecjwHjz1Nz+c2vqbbL7A3I61mu1oXxT2Bz3S
         nEwjbvwMHIwfMfRJQWPOZC/M0bXJpMCVZUF291i4ZePlI8IcSOFcVHhdRI0rxOLxWgAG
         PNsg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788184034; x=1788788834; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZXdZhCAXl/YPLluX+b217oaIUS3C82lBDYKPatd622s=;
        b=lRp5bbzkRDRp1K+S8y1GX09DnnKFU7PE1Gbf6wVUdRHBAavcLK4s2XmKkW5zbMKSUK
         k6b2AzuuUC9a7Z1nvd3ZtIdvJdHipXL1J/VlYPmBCx1NiiALUOaF5dPz/a496trHg7fP
         chBjZyGRuV3NAxUkFIASlQW2GilvxdaVd+N9cTSaGr6H6Xp85ws7MyjeWL/sI3eB5VXc
         /7EcPZd2gmttVD7+Li51Rynu7ka0bZ/3j2Q+422slcn6kD7sSyGPEzjjpp25mnyuTqt8
         L2eMwDUbUrNAhy9+xgz5EAq0+G462Ra1/xGYwnCNWRb/7Ds9favOJtVkBQJYNin17pzh
         IH+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788184034; x=1788788834;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZXdZhCAXl/YPLluX+b217oaIUS3C82lBDYKPatd622s=;
        b=XwZ6C0MNwSFVie06NqO0Ja8A7JNkiG2NnjBz3Y0RjN8/IRMr6AWFoVZpbTq2yDBNjR
         mqIP2dLtQQKtFd96V1AUTZUnzlRStFxLBDMy3FQYOMsQdnxHghPn7CfVjYp+quYi/QIK
         GrXUvFJeSh2Sz7uJ4rt2ZJgeM4v95ezMqKbXqzYD5LvDkGSawIhAfmBi8uEsXOPBOJI4
         rTKy0p5yfMyZRflKlnipATjBSNFOsrXj9P0mhGVyNrphtHbY+CHex/035dGAvmhTO2aG
         stMWyGhyGfkTJw1FUadTSp1IivO3TwbIeo53h/W2LRJd7paZKsRnP4Y2ecuDSHgnoDRu
         YwSA==
X-Forwarded-Encrypted: i=1; AHgh+RrPAGQqVKC216n4NhfmdktvBxK4gkWwHGdmU6QCd4xbduYrWBtHoqozkRDaiRhfBsf7LKeTDZj2a5okVqZF@vger.kernel.org
X-Gm-Message-State: AFuF++m3tadZy9yIqapFzo6eSxG+lat8L6cgwKf/FF1R7lnbw53bPos1
	XSM8D1pP4Bqpzf9+29bsJ5zNLA8Blo04KmUDGDCXNa4f/KUC7ZB1QUno89HRiGZ/xbhcJ+ELpww
	VdE6JDYfzUnFIi184Cg8KW+hjgv735hw=
X-Gm-Gg: AR+sD13uqr1KAtTje59DU1DSi5SF/UIL3Jj9hFzmVFG9PvsnR5BaWrIKIwWUFMVcDdM
	YQZQ6U6mGMRdQimkZgt9jdNxT7c1Tx5cAlZuMuUbQ+YvusCl5VO+LOqg+6byC1ujhFvq3cmhWLz
	pt80jl0cR7w4q6oqY3UaP1xwKT5RRRCnT/U4PbwWArsYvWOKAJLSgesvz2pe/yEYgha1oUwO1gS
	ZTShV54Gx8IMB/TJiu8vCZaJFpdAS4966N6xXzAn8b6wimgAOJNKmDqSZKL+3OH3uZcaYY7Ad62
	O6zpkwDZBjyVe6dT2EbYU4jYRgfoIV+SyYYJqk584V4VKQ==
X-Received: by 2002:a05:6870:9d94:b0:46a:9a34:c571 with SMTP id
 586e51a60fabf-46af57f1aa7mr1054584fac.19.1788184033715; Mon, 31 Aug 2026
 06:47:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260829213256.51527-1-kmehltretter@gmail.com> <20260829213256.51527-2-kmehltretter@gmail.com>
In-Reply-To: <20260829213256.51527-2-kmehltretter@gmail.com>
From: Stephen Smalley <stephen.smalley.work@gmail.com>
Date: Mon, 31 Aug 2026 09:47:02 -0400
X-Gm-Features: AcwNN1XH17mTpK2KblerbVrKlCve1RclfFZ2A5wUG-rwX01P42n-jv3618nmM4k
Message-ID: <CAEjxPJ656tz7PZuVfKU5W6tBU01-Y2+EoD3wLQBanDnj2CbXng@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] selinux: preserve user SID across nested backing files
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: selinux@vger.kernel.org, Paul Moore <paul@paul-moore.com>, 
	Ondrej Mosnacek <omosnace@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Amir Goldstein <amir73il@gmail.com>, Christian Brauner <brauner@kernel.org>, 
	Baokun Li <libaokun@linux.alibaba.com>, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 29, 2026 at 5:33=E2=80=AFPM Karl Mehltretter <kmehltretter@gmai=
l.com> wrote:
>
> SELinux saves the user file SID in a backing-file security blob so it
> remains available after mmap() replaces vma->vm_file with a backing file.
>
> For nested backing files (overlayfs over overlayfs, or FUSE passthrough
> backed by overlayfs), user_file may itself be a backing file.  Its
> fsec->sid is the SID of the mounter that opened it, rather than the user
> that opened the top-level file.  mprotect() then checks fd { use } agains=
t
> the mounter SID.  This can incorrectly deny access without a domain
> transition, or check the wrong target SID after one.
>
> Copy the saved user SID when user_file is a backing file.  Keep using the
> regular file SID for the first backing layer.
>
> With two nested overlayfs mounts and SELinux enforcing,
> mprotect(PROT_READ) returns EACCES with an fd { use } denial against the
> mounter SID.  With this change, mprotect() succeeds.
>
> Tested on arm64 QEMU with a small BusyBox initramfs and a purpose-built
> SELinux policy.  The original test was also repeated with Fedora Cloud
> Base 44 userspace and gave the same result.
>
> Fixes: 82544d36b172 ("selinux: fix overlayfs mmap() and mprotect() access=
 checks")
> Cc: <stable@vger.kernel.org>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>

Reviewed-by: Stephen Smalley <stephen.smalley.work@gmail.com>
