Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CD7AC2BB3F
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Nov 2023 01:07:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbjKPBIB (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 15 Nov 2023 20:08:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjKPBIA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 15 Nov 2023 20:08:00 -0500
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56CC18B
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Nov 2023 17:07:56 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id af79cd13be357-7789923612dso13851085a.0
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Nov 2023 17:07:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.cmu.edu; s=google-2021; t=1700096876; x=1700701676; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ks3PBWIiV94MxOqwQB5+8Db6JJTMEhrY5Td5vGNu9Ss=;
        b=DiW1nVsADuZDF8b+NIyhmPmVYUbe4H8CvzUPknqiqIyUgiqmkD1jGa/jkdXnMChJKx
         lUjT1ZpBAqwmOmAEIiMQ8mDFI1XubjzoMqNGgOKro4qCXo4PPWkvZ/JV6HR1rFIKnITp
         huDvER0n3yQQN1oG3jBuV2vYGsC91JYqlRIU2Da9H152mWMsTueKcPNGkpu7Mfs+RW9Z
         Lgpx3Raidvn4UIr4ZHaasTlDBjL8S7i21uGIJMvbixHHjhGsPp+IY+DQFOPh2YbGt3yX
         jhNw5pTtkpKUZF7d8VH+v/NjwKq7gzGto7jfh3fh/Nmqfk9ZZMAw3uZ7OX3MYpvLlWBJ
         Hr8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700096876; x=1700701676;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ks3PBWIiV94MxOqwQB5+8Db6JJTMEhrY5Td5vGNu9Ss=;
        b=t5Nq2kRq1sr9WebxkN/U4of7j6Z/PMmzqKp8aVo5Si3SSzNDKOp3PfvE8m9Mu6jx4O
         KD24+N0hiipks2650Z8pkV2y2QYSg2JnonnAjty86GcVWlviBQ98Or2G+6SsUeFr7jO8
         QzsIVhw7nULLBlxrapOZ6+bhjyy+/aLex/uyKnAjQYj742kSFTYy1ZzqIx659HpKzwn3
         RAz2ZNbCcQeHMo2jfoa/cKZRQDq3QkRT4mxDNfv4OYO8RWWHAaWWlaCVyWwzRzwUFSg5
         enp0sags7FST5w+kFQc3gWLrYn5JEBWJGagWGI+P7VtyGmbUed0hCo52OHc5U++Ip2Vi
         QHyA==
X-Gm-Message-State: AOJu0Yz5YhdaIQdnTSMi+TX6AXgt7BtMAMByA2ocOEwmZAnpV3yoFM2F
        Na5J9Pmh0/Qa6AyiMwP9/LYAOg==
X-Google-Smtp-Source: AGHT+IHQBCuV3ZHYVIXo0mYxxtYvG/z3Rp1iF7T/0KnrIuWHrzL+jfuGD8XXyjG+QorM2yf5Z6lcFA==
X-Received: by 2002:a05:620a:40c2:b0:76c:ea3f:9010 with SMTP id g2-20020a05620a40c200b0076cea3f9010mr9406602qko.16.1700096875996;
        Wed, 15 Nov 2023 17:07:55 -0800 (PST)
Received: from cs.cmu.edu (tunnel29655-pt.tunnel.tserv13.ash1.ipv6.he.net. [2001:470:7:582::2])
        by smtp.gmail.com with ESMTPSA id x4-20020a05620a14a400b0077438383a07sm3904019qkj.80.2023.11.15.17.07.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Nov 2023 17:07:55 -0800 (PST)
Date:   Wed, 15 Nov 2023 20:07:53 -0500
From:   Jan Harkes <jaharkes@cs.cmu.edu>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org,
        Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 09/15] fs: move file_start_write() into vfs_iter_write()
Message-ID: <20231116010753.f3nptj4urhfcynnt@cs.cmu.edu>
Mail-Followup-To: Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
References: <20231114153254.1715969-1-amir73il@gmail.com>
 <20231114153254.1715969-10-amir73il@gmail.com>
 <20231114234209.f626le55r5if4fbp@cs.cmu.edu>
 <CAOQ4uxjcnwuF1gMxe64WLODGA_MyAy8x-DtqkCUxqVQKk3Xbng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxjcnwuF1gMxe64WLODGA_MyAy8x-DtqkCUxqVQKk3Xbng@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Nov 15, 2023 at 11:01:39AM +0200, Amir Goldstein wrote:
> On Wed, Nov 15, 2023 at 1:42 AM Jan Harkes <jaharkes@cs.cmu.edu> wrote:
> >  * Since freeze protection behaves as a lock, users have to preserve
> >  * ordering of freeze protection and other filesystem locks. Generally,
> >  * freeze protection should be the outermost lock. In particular, we
> >  * have:
> >  *
> >  * sb_start_write
> >  *   -> i_mutex                 (write path, truncate, directory ops,
> >  *   ...)
> >  *   -> s_umount                (freeze_super, thaw_super)
> >
> 
> This describes the locking order within a specific fs.
> host_file is not in the same fs as code_inode.
> 
> IIUC, host_file is a sort of backing file for the code inode.
> In cases like this, as in cachefiles and overlayfs, it is best
> to order all backing fs locks strictly after all the frontend fs locks.
> See ovl_write_iter() for example.
> 
> IOW, the new lock ordering is preferred:
> file_start_write(coda_file)
>   inode_lock(code_inode)
>     file_start_write(host_file)
>       inode_lock(host_inode)

Well, if everybody else is doing it, I guess it must be ok.

Jan
