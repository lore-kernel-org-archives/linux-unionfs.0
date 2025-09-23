Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85271324B20
	for <linux-unionfs@vger.kernel.org>; Tue, 23 Sep 2025 13:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758633426; cv=none; b=heZgAp4CPVgjwOOEIsNSkW+JI5PMvWzCji7QXWMtZiPlmpnuoPCzF0BIlvRqmGRjUqux583O2JQoOkcW0uPZDnPVwS+ZNsu1oBWUuai13EgAeS5ubl2bjagqlUBnZnP+wxs7fzXRqXa01pstsVkdtbVD6TIyaAYcKn6dJIXtz0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758633426; c=relaxed/simple;
	bh=MjdyuQrqVvsTBegSnd3yU00JR+DMJq7p6mLUJWTlZdU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L/8CpRyCFwCDQFLOqHAwofGhEeH58kjQI2eODO/QMZJtp1CerxdBQKKQszn7nuHC8tnum1VmFLJPqlOLiSmhI0hIYEDd+kIFkiE8R65KQ8bb1j4Wr6sY1OAdNjOj2W6k52JGCeElGuyr5lJS1VnUpjoUIooPz8AsIEpg8G2LA8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=yGwEv5jd; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="yGwEv5jd"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b54a74f9150so4103755a12.0
        for <linux-unionfs@vger.kernel.org>; Tue, 23 Sep 2025 06:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1758633424; x=1759238224; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DGZ8DWqCix+BtHtElOYwM96MkEfMXUBhKMzH5BSjHrU=;
        b=yGwEv5jdMt4Rgfi0m0bN3rxya9s2FAbia8xtqcTwhc19IK5r4PXmdK+C7UWreg1NfH
         4sk+1SJaFqWoZk8UMTPHgcndklOJpzScvLF5bjkG6gqoUSKB2k3ZVGlgvwgMKVkiX9tQ
         HMMHDCD3TrzFuqxXTV9HAJcgYYX2He2h5yQzLxkZURdzd28u2rXo3M/TKNd/GoKCTF5R
         SSJHzKnVcZ1kR/S8ehZjuwzeAqAlS4edQgRc1y0V8xkXIINs5b4r82gsRo8F8hz5liGg
         WFWMrwFtm4OO2twE/EkvNGL9ESDPBnyP6iVe3AlnhcR6cmuUPbA6c7z1EUU5XrhnwxMP
         WISA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758633424; x=1759238224;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DGZ8DWqCix+BtHtElOYwM96MkEfMXUBhKMzH5BSjHrU=;
        b=bRNVvXBx8cOD4YL8IIM7O26JVXu9V6macF7uAWc/MpjQE19HDK8axuFhkdbcWB+PAV
         UpGc9I4SWOFb4Rq8vgjdhZFWq03mDf/xRRXDGU2zaqB6YG1mIVZRc3jlWKJit1T17357
         yn5CpftNKFbR2pGPsK7QvS6CuPEqqtnqykJMUI6yFkIafE53F27Xiuk1CSApIJBNWI7O
         qzN4OzI3JKQO+dUYLi1TUZjDzedNozCC6/mYmju/0DJmKb+J0Z1buez9GbXetNxVN0bZ
         Zw2aQ3F6GRgGqWltpOsNpQsuaUXLSWFabVfUEujTRMuzQZUh0RuMlcUIcH7Yet2uwzvA
         4KaQ==
X-Forwarded-Encrypted: i=1; AJvYcCVqAGaUMFbo1exsUVr/7q3PyHQA2q7hHhc0gYk6U/1fqZzo3qHUxPilBBwu5445/AXojqcGJY8yMMOLREku@vger.kernel.org
X-Gm-Message-State: AOJu0YzLUAJI57/Qwvy8S2wQyN9KPXHwJfdswyPBjNK+cEROeJPjz987
	dXjxuTsNy1o3W/SelUZhKV8gj4YsG696Edx0trp+aexcSw1DNCj/rPAKFCkd9LMj2rg=
X-Gm-Gg: ASbGncsrCputxzleZJuWFmQ9BnkK3G1DydQAsqQxK4lgjhIofyd+BnXLHWbFXFirmLw
	2hh/It9WeUO6/KVN1vStjZ/tTMatWpub3SMv7Qgp9GW5qeB88/74SeNYXXSPxFaXjFb8XhFCRCm
	9FQZZs4w1MfrKc4LmGraIgElTCsckQX9TMjZAEulZmFLvmXgso0u6Tr2gexfrA7ubpPh25vQ0Xj
	mq8fLtNPp9NcCq62d/JFg/D9pXob3nV5zQmHDad1nmGxMaumf87LeB+MxuH87mcUDQnZ6b+LpQZ
	JFSN89zyS7WfJN6ghXKWfr/BffjFWR5AkbK4QQxkEHEBRiaNmrqlwIsfF/t8HViwHpzqcE8KJL2
	i92lZYbX7TlU80ret0t82tPod0qtfFoL1tPO2psD7cDgs616E38pNhgBVzqIUSTPldObbwnLyDX
	3Z05hciRnb
X-Google-Smtp-Source: AGHT+IEK7PfWxNFc7fb1bUErPP+++ZIWocUE2B9M31SxyszIkGAjugG30aXgLbzSTbCpFRJZYYXACg==
X-Received: by 2002:a17:90b:17cc:b0:32b:9750:10e4 with SMTP id 98e67ed59e1d1-332a95e0514mr2945365a91.27.1758633423462;
        Tue, 23 Sep 2025 06:17:03 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b551705bd02sm12047994a12.41.2025.09.23.06.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Sep 2025 06:17:02 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1v12t9-00000005h4t-0IOy;
	Tue, 23 Sep 2025 23:16:59 +1000
Date: Tue, 23 Sep 2025 23:16:59 +1000
From: Dave Chinner <david@fromorbit.com>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	josef@toxicpanda.com, kernel-team@fb.com, amir73il@gmail.com,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, ceph-devel@vger.kernel.org,
	linux-unionfs@vger.kernel.org
Subject: Re: [PATCH v6 0/4] hide ->i_state behind accessors
Message-ID: <aNKdy1vYsWoMvU3c@dread.disaster.area>
References: <20250923104710.2973493-1-mjguzik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250923104710.2973493-1-mjguzik@gmail.com>

On Tue, Sep 23, 2025 at 12:47:06PM +0200, Mateusz Guzik wrote:
> First commit message quoted verbatim with rationable + API:
> 
> [quote]
> Open-coded accesses prevent asserting they are done correctly. One
> obvious aspect is locking, but significantly more can checked. For
> example it can be detected when the code is clearing flags which are
> already missing, or is setting flags when it is illegal (e.g., I_FREEING
> when ->i_count > 0).
> 
> Given the late stage of the release cycle this patchset only aims to
> hide access, it does not provide any of the checks.
> 
> Consumers can be trivially converted. Suppose flags I_A and I_B are to
> be handled, then:
> 
> state = inode->i_state          => state = inode_state_read(inode)
> inode->i_state |= (I_A | I_B)   => inode_state_set(inode, I_A | I_B)
> inode->i_state &= ~(I_A | I_B)  => inode_state_clear(inode, I_A | I_B)
> inode->i_state = I_A | I_B      => inode_state_assign(inode, I_A | I_B)
> [/quote]
> 
> Right now this is one big NOP, except for READ_ONCE/WRITE_ONCE for every access.
> 
> Given this, I decided to not submit any per-fs patches. Instead, the
> conversion is done in 2 parts: coccinelle and whatever which was missed.
> 
> Generated against:
> https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git/commit/?h=vfs-6.18.inode.refcount.preliminaries

Much simpler and nicer than the earlier versions. Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
