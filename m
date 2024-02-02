Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A57812D763
	for <linux-unionfs@vger.kernel.org>; Fri,  2 Feb 2024 18:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706899991; cv=none; b=U5EM/k0fiv8ZgGBS3EtbUbXKp3eSMB0DZ44FqGDGRRNrmYoBWOvpHB/QL16e7AJDcV7gvWnDwJP2v7hi4t2jUGSDwZWrFAgTGcfF011nT8BFa6swuqMQQ9bM0NDWqpG8AyJJbwSZsDfKvEVrXVRkf298ebyzpYYoBb2/ktm855E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706899991; c=relaxed/simple;
	bh=m/WNcjkdV8P5r0Sxba88Rpog+SUIXXCthzgB5O2xWNk=;
	h=Date:Message-ID:MIME-Version:Content-Type:Content-Disposition:
	 From:To:Cc:Subject:References:In-Reply-To; b=ZM0b7EZo4bOsfjXi0XEI0Qw1BZeG28IzX2CF3wCjr41czfDhJke5mBVzKRV4OkFojkGErtBND6jyKPuCB4h/NLotGrvyebl3gWgBIoZELMu1S30PI2cQ5okvjInK349nhh6ep87yHB9h6syj736FzHqKhfGBombdMsECJ535a2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=CNsM7PSf; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="CNsM7PSf"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-429d7896d35so15195161cf.3
        for <linux-unionfs@vger.kernel.org>; Fri, 02 Feb 2024 10:53:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1706899988; x=1707504788; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-disposition:mime-version:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5c/+Y14mHHaPKHRNHulUs8NEoekW9Eg8T7lalEP2Fao=;
        b=CNsM7PSf3mz4eABEO6zqqfEZOHp1dVu4KTRKF/DOTBozW1etRVaHg87ayfXYsTVzvk
         Vmh9Q7jqr0UKPvNT2BmrosaE4Oom7NFWJmm/DN98Jo2fBGPtPOFyXd7PeH11pNXW4oWv
         MyW/cz/ugpfXWaYimm3IhCs6eETFkcRt4+2hXc5fNvLTZfoxKZKsQFJN69hlJdfFhDDw
         tFeqDfLoOHtAls/AJh8LJfCCzsSzAERXb8AwWEVvXwRW6dipwUWL+IeG0EirDQAcp/GC
         B75T9D5Zh/snOFk0qrItsaG4x5SpTIuHyabOzM0LIHgpZuIjOJX8RgjSwIggVy7lS0cy
         VKiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706899988; x=1707504788;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-disposition:mime-version:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5c/+Y14mHHaPKHRNHulUs8NEoekW9Eg8T7lalEP2Fao=;
        b=GcsV+oWigIecdEzIYT/qKWgiI1NB7NxvNy0JxZNYsCuXjTxrQwg+L+c5PnGreO0Xr8
         EhmyIRZR+KuzhEvJYiexbO7M+RT7wCrdOGU8nvC/YXinI3BN+//SB3puQPmHv+SE65Sf
         t7eJDAxs6FUnmx2CCOaz5IdhOMDfSPfXP6T2p5zzQYewGV5Uqr9trDLaH0Qm3qdduvNe
         gLPSMqNvM2l+ivsFwzWmvpdmEBgV9sp3JztJOvbZ71TvjwefXdBB0V70dAAoxll/NlYh
         BOx8GtkCU72iQ7gGRzX2T6W3AnWBJwI7Csp/YCXPwqQP80yEBeroUctXJEdqrQVhN2fI
         1wfA==
X-Gm-Message-State: AOJu0Yz3PsEzIfIJzIuEsm3TIBLzQgBoY4g/fSAJ/tNQz8ySUp26ilUD
	c31YPvUsu//r4AgTxUFf+1nP/EioDqrZkles6d6ZVXdiivmOwbBYn14y/uHhlA==
X-Google-Smtp-Source: AGHT+IE5ZOvJQA9TkN0X9ZbePnSK6Ln+XEVPx6Bi5iNK4XGRaTjTX/MVVfZ4GNK5kG1/wMT71I+Kqw==
X-Received: by 2002:a05:6214:300a:b0:68c:6f68:f250 with SMTP id ke10-20020a056214300a00b0068c6f68f250mr8816371qvb.45.1706899988379;
        Fri, 02 Feb 2024 10:53:08 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCXLCmkiJEMDAOkX8ITg/DACqm5b4hdnKNmsYeh0ZThZKb9B0BtiGtstOgmvp6IEz65SVxEm1oGS630ivkMuag1H5JvA0vOp3Q==
Received: from localhost ([70.22.175.108])
        by smtp.gmail.com with ESMTPSA id dm18-20020ad44e32000000b0068181b61183sm1051089qvb.31.2024.02.02.10.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Feb 2024 10:53:06 -0800 (PST)
Date: Fri, 02 Feb 2024 13:53:06 -0500
Message-ID: <5ec703e783241a5a6d440cef68a6fcb9@paul-moore.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 
Content-Type: text/plain; charset=utf-8 
Content-Disposition: inline 
Content-Transfer-Encoding: 8bit
From: Paul Moore <paul@paul-moore.com>
To: David Disseldorp <ddiss@suse.de>, selinux@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org
Subject: Re: [PATCH v2] selinux: only filter copy-up xattrs following  initialization
References: <20240202064048.29881-1-ddiss@suse.de>
In-Reply-To: <20240202064048.29881-1-ddiss@suse.de>

On Feb  2, 2024 David Disseldorp <ddiss@suse.de> wrote:
> 
> Extended attribute copy-up functionality added via 19472b69d639d
> ("selinux: Implementation for inode_copy_up_xattr() hook") sees
> "security.selinux" contexts dropped, instead relying on contexts
> applied via the inode_copy_up() hook.
> 
> When copy-up takes place during early boot, prior to selinux
> initialization / policy load, the context stripping can be unwanted
> and unexpected.
> 
> With this change, filtering of "security.selinux" xattrs will only occur
> after selinux initialization.
> 
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---
> Changes since v1:
> - drop RFC
> - slightly rework commit message and preceeding comment
> 
>  security/selinux/hooks.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Merged into selinux/dev, thanks for following up on this.

--
paul-moore.com
