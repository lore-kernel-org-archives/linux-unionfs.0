Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47773E552
	for <linux-unionfs@vger.kernel.org>; Sat, 28 Jun 2025 03:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751080096; cv=none; b=T4kF7MVcs2qS/1YKiCuTJCnbO51AkdDScsZ5VvtGci6JB12wWhnMJ63XW2NxloaLtzWU4bWiCcbXtsf678xSmwA9Ky7pzFgTM8w8ZFlRX3yBf2kPY8tvdpknwcooA1KVOO1XzRvHWECYnJiGlu+av8+IN4982DOuFHRsVs9DRZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751080096; c=relaxed/simple;
	bh=F4jRPYPK3HZQp41xTMVS090WqXhuuPrEtD6Fu72Rs8M=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=JzzUf0nLmiHw3I90Pmdm0AgOiyny7rD38DtH7EUX9aUO+ALi2MAa39MvK4c4o3l6JEUsdnh7ajHaZtdXIRTuAVzUyiPPDlWdR9p5n9PiDYeCravbU2S4UjixiFprlt4N4p3R4szOzcGlFHmC+9Nhk0X74gLix7F22fgILMvVp8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mjekDsAY; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mjekDsAY"
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-4080548891fso1123425b6e.3
        for <linux-unionfs@vger.kernel.org>; Fri, 27 Jun 2025 20:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751080093; x=1751684893; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=R5C7wDOCk564OEWFH7M2aZZ1aNq6jn/MMfPLPriA7Zg=;
        b=mjekDsAYOmSLcSagCh98ydwjNJ4ncEzLPEmLFcWVyCOxThQvLwuG8RuBsMMIg97ZZO
         cG/wBxYN6ZT4cUL/ysFce3omjkPEr6pgD2gbKHy/7MM47dwLg9TTegyS3jKAz1nt19nN
         fGWn2VlVQb55qG62dshAA9T50MvbNY//FXmkCh6bcTTRCwPflHtES2U2OII2uxWpdh3E
         SiNgTvC59oNgPg/Rx474Cxaw5eVmVTTQpUjxXgNMlHs48P6b3C303SOLnTU5+bFtRv2k
         7u6hU64wlq74RGHqwQLsqv7pH//Lb2yJmVd2j2EgxJu5ybc0Nx2WuSeqy67EGJMxAtt3
         HAEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751080093; x=1751684893;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R5C7wDOCk564OEWFH7M2aZZ1aNq6jn/MMfPLPriA7Zg=;
        b=WOi4HbQxm3sZZN+Nd7lzM1lWL8y/SOMdKvfNpYYTR9bYagzzTrZpBMzVTlnvNcWkFy
         bIrgt4vfjCYhzC78+/aQUkM6fNilkhplcRmfGVrTihwTKcbllaPUs0KwjtKDBr6iOCVQ
         P1EWaxROSN1HifMmvJwperJNTWqHq8VHaeBqKiHqRRRRB86B+n5k3SjZ4EcOvIJDwKex
         JiX8CTAIk3Tels4JzyrEPtXnCzisfYZy1gG2DbPepWrwtJkW10vIqXgy2Ztn9sY7x1PR
         l0naw93AyqL7j2VqnxFvH7+mPqoIJSSOotCYfSA7mYVdOxIS3phHUXCLgQzErUcUTu5G
         ue6g==
X-Forwarded-Encrypted: i=1; AJvYcCXcSEdabZd21hTWgKf/FdGwfW2LOsWZoVBaiZ1PEdpB9RJ2nujCiz7d6NLudv3vIixyzsquGU9llqmNkIUV@vger.kernel.org
X-Gm-Message-State: AOJu0YwDEnRumdmpNAfDm4q6pROSTU78c7y4tJwwrlWGCylhA+nNQ4WS
	+RAsby74O9MurkTrKN/Pw8GAu4P6hjCUeDqAolWDSOYQbz+Y/OHU2RPOYxPCi6qJ4Ac=
X-Gm-Gg: ASbGncuhsfs1rdPlmPcdMmdFUE6mILbU8HKE5pQb4qENXchgOfVxMXC+ZMmBRECWd0c
	HDY+hKOxtyeTaJrhA7qrJjfZBaz3VuyQAsL/+GoHu1TZVZY4fqGf/X+4eLueY16Kd/dUwu46oeg
	XFA7pKKh3f3W40fQd5zRr1tlg5pw6vRqyWS3FZYzI9NBPCjSk9IOd6C2HqFLVM9Chg6/cWa4GiA
	Peypd8f1CwN7fnsyT2v4fk9Mr5CJpncUjQiuAgbJxeIItKTH5ewL0sDMLMbw7BAcwH07T77j88k
	/5MQ5in5SDap1U0tWbZU/6/S3thr17pK72M0xDTqVVhkw268ALRvsogLnZAC1XvJSrBq7A==
X-Google-Smtp-Source: AGHT+IE9p/mIcciNCswT4RuAtH/FPSvIxBlffkNmLxu9P9Tp83tKg9+5M+mI2y7FVTOhrZhMjnCp2g==
X-Received: by 2002:a05:6808:318f:b0:3fe:b1fd:527f with SMTP id 5614622812f47-40b33c18540mr4463308b6e.1.1751080093399;
        Fri, 27 Jun 2025 20:08:13 -0700 (PDT)
Received: from localhost ([2603:8080:b800:f700:f3a4:7b11:3bf4:5d7b])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-73afb006480sm631924a34.21.2025.06.27.20.08.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jun 2025 20:08:12 -0700 (PDT)
Date: Sat, 28 Jun 2025 06:08:10 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oe-kbuild@lists.linux.dev, NeilBrown <neil@brown.name>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	linux-unionfs@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 02/12] ovl: Call ovl_create_temp() and ovl_create_index()
 without lock held.
Message-ID: <98d78667-cd7d-40d8-b5d8-7f5973d012e7@suswa.mountain>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250624230636.3233059-3-neil@brown.name>

Hi NeilBrown,

kernel test robot noticed the following build warnings:

https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/NeilBrown/ovl-use-is_subdir-for-testing-if-one-thing-is-a-subdir-of-another/20250625-070919
base:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git vfs.all
patch link:    https://lore.kernel.org/r/20250624230636.3233059-3-neil%40brown.name
patch subject: [PATCH 02/12] ovl: Call ovl_create_temp() and ovl_create_index() without lock held.
config: x86_64-randconfig-161-20250627 (https://download.01.org/0day-ci/archive/20250628/202506281017.jeQF1pnr-lkp@intel.com/config)
compiler: clang version 20.1.7 (https://github.com/llvm/llvm-project 6146a88f60492b520a36f8f8f3231e15f3cc6082)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
| Closes: https://lore.kernel.org/r/202506281017.jeQF1pnr-lkp@intel.com/

New smatch warnings:
fs/overlayfs/dir.c:427 ovl_clear_empty() warn: passing zero to 'ERR_PTR'

vim +/ERR_PTR +427 fs/overlayfs/dir.c

e9be9d5e76e348 Miklos Szeredi    2014-10-24  353  static struct dentry *ovl_clear_empty(struct dentry *dentry,
e9be9d5e76e348 Miklos Szeredi    2014-10-24  354  				      struct list_head *list)
e9be9d5e76e348 Miklos Szeredi    2014-10-24  355  {
576bb263450bbb Christian Brauner 2022-04-04  356  	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
e9be9d5e76e348 Miklos Szeredi    2014-10-24  357  	struct dentry *workdir = ovl_workdir(dentry);
e9be9d5e76e348 Miklos Szeredi    2014-10-24  358  	struct inode *wdir = workdir->d_inode;
e9be9d5e76e348 Miklos Szeredi    2014-10-24  359  	struct dentry *upperdir = ovl_dentry_upper(dentry->d_parent);
e9be9d5e76e348 Miklos Szeredi    2014-10-24  360  	struct inode *udir = upperdir->d_inode;
e9be9d5e76e348 Miklos Szeredi    2014-10-24  361  	struct path upperpath;
e9be9d5e76e348 Miklos Szeredi    2014-10-24  362  	struct dentry *upper;
e9be9d5e76e348 Miklos Szeredi    2014-10-24  363  	struct dentry *opaquedir;
e9be9d5e76e348 Miklos Szeredi    2014-10-24  364  	struct kstat stat;
e9be9d5e76e348 Miklos Szeredi    2014-10-24  365  	int err;
e9be9d5e76e348 Miklos Szeredi    2014-10-24  366  
cc6f67bcafcb6b Miklos Szeredi    2015-05-19  367  	if (WARN_ON(!workdir))
cc6f67bcafcb6b Miklos Szeredi    2015-05-19  368  		return ERR_PTR(-EROFS);
cc6f67bcafcb6b Miklos Szeredi    2015-05-19  369  
e9be9d5e76e348 Miklos Szeredi    2014-10-24  370  	ovl_path_upper(dentry, &upperpath);
a528d35e8bfcc5 David Howells     2017-01-31  371  	err = vfs_getattr(&upperpath, &stat,
a528d35e8bfcc5 David Howells     2017-01-31  372  			  STATX_BASIC_STATS, AT_STATX_SYNC_AS_STAT);
e9be9d5e76e348 Miklos Szeredi    2014-10-24  373  	if (err)
fb1b87daadb6ed NeilBrown         2025-06-25  374  		goto out;
e9be9d5e76e348 Miklos Szeredi    2014-10-24  375  
e9be9d5e76e348 Miklos Szeredi    2014-10-24  376  	err = -ESTALE;
e9be9d5e76e348 Miklos Szeredi    2014-10-24  377  	if (!S_ISDIR(stat.mode))
fb1b87daadb6ed NeilBrown         2025-06-25  378  		goto out;
e9be9d5e76e348 Miklos Szeredi    2014-10-24  379  	upper = upperpath.dentry;
fb1b87daadb6ed NeilBrown         2025-06-25  380  	/* This test is racey but we re-test under the lock */
fb1b87daadb6ed NeilBrown         2025-06-25  381  	if (upper->d_parent != upperdir)
fb1b87daadb6ed NeilBrown         2025-06-25  382  		goto out;
e9be9d5e76e348 Miklos Szeredi    2014-10-24  383  
576bb263450bbb Christian Brauner 2022-04-04  384  	opaquedir = ovl_create_temp(ofs, workdir, OVL_CATTR(stat.mode));
e9be9d5e76e348 Miklos Szeredi    2014-10-24  385  	err = PTR_ERR(opaquedir);
e9be9d5e76e348 Miklos Szeredi    2014-10-24  386  	if (IS_ERR(opaquedir))
fb1b87daadb6ed NeilBrown         2025-06-25  387  		/* workdir was unlocked, no upperdir */
fb1b87daadb6ed NeilBrown         2025-06-25  388  		goto out;
fb1b87daadb6ed NeilBrown         2025-06-25  389  	err = ovl_lock_rename_workdir(workdir, upperdir);
fb1b87daadb6ed NeilBrown         2025-06-25  390  	if (err)
fb1b87daadb6ed NeilBrown         2025-06-25  391  		goto out_cleanup_unlocked;
fb1b87daadb6ed NeilBrown         2025-06-25  392  	if (upper->d_parent->d_inode != udir)
fb1b87daadb6ed NeilBrown         2025-06-25  393  		goto out_cleanup;

Should there be an error code for this?

dad7017a840d8d Christian Brauner 2022-04-04  394  	err = ovl_copy_xattr(dentry->d_sb, &upperpath, opaquedir);
e9be9d5e76e348 Miklos Szeredi    2014-10-24  395  	if (err)
e9be9d5e76e348 Miklos Szeredi    2014-10-24  396  		goto out_cleanup;
e9be9d5e76e348 Miklos Szeredi    2014-10-24  397  
5cf5b477f0ca33 Miklos Szeredi    2016-12-16  398  	err = ovl_set_opaque(dentry, opaquedir);
e9be9d5e76e348 Miklos Szeredi    2014-10-24  399  	if (err)
e9be9d5e76e348 Miklos Szeredi    2014-10-24  400  		goto out_cleanup;
e9be9d5e76e348 Miklos Szeredi    2014-10-24  401  
5955102c9984fa Al Viro           2016-01-22  402  	inode_lock(opaquedir->d_inode);
5272eaf3a56827 Christian Brauner 2022-04-04  403  	err = ovl_set_attr(ofs, opaquedir, &stat);
5955102c9984fa Al Viro           2016-01-22  404  	inode_unlock(opaquedir->d_inode);
e9be9d5e76e348 Miklos Szeredi    2014-10-24  405  	if (err)
e9be9d5e76e348 Miklos Szeredi    2014-10-24  406  		goto out_cleanup;
e9be9d5e76e348 Miklos Szeredi    2014-10-24  407  
bc9241367aac08 NeilBrown         2025-06-13  408  	err = ovl_do_rename(ofs, workdir, opaquedir, upperdir, upper, RENAME_EXCHANGE);
e9be9d5e76e348 Miklos Szeredi    2014-10-24  409  	if (err)
e9be9d5e76e348 Miklos Szeredi    2014-10-24  410  		goto out_cleanup;
e9be9d5e76e348 Miklos Szeredi    2014-10-24  411  
576bb263450bbb Christian Brauner 2022-04-04  412  	ovl_cleanup_whiteouts(ofs, upper, list);
576bb263450bbb Christian Brauner 2022-04-04  413  	ovl_cleanup(ofs, wdir, upper);
e9be9d5e76e348 Miklos Szeredi    2014-10-24  414  	unlock_rename(workdir, upperdir);
e9be9d5e76e348 Miklos Szeredi    2014-10-24  415  
e9be9d5e76e348 Miklos Szeredi    2014-10-24  416  	/* dentry's upper doesn't match now, get rid of it */
e9be9d5e76e348 Miklos Szeredi    2014-10-24  417  	d_drop(dentry);
e9be9d5e76e348 Miklos Szeredi    2014-10-24  418  
e9be9d5e76e348 Miklos Szeredi    2014-10-24  419  	return opaquedir;
e9be9d5e76e348 Miklos Szeredi    2014-10-24  420  
e9be9d5e76e348 Miklos Szeredi    2014-10-24  421  out_cleanup:
e9be9d5e76e348 Miklos Szeredi    2014-10-24  422  	unlock_rename(workdir, upperdir);
fb1b87daadb6ed NeilBrown         2025-06-25  423  out_cleanup_unlocked:
fb1b87daadb6ed NeilBrown         2025-06-25  424  	ovl_cleanup_unlocked(ofs, workdir, opaquedir);
fb1b87daadb6ed NeilBrown         2025-06-25  425  	dput(opaquedir);
e9be9d5e76e348 Miklos Szeredi    2014-10-24  426  out:
e9be9d5e76e348 Miklos Szeredi    2014-10-24 @427  	return ERR_PTR(err);
e9be9d5e76e348 Miklos Szeredi    2014-10-24  428  }

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

