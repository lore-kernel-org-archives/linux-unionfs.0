From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 1/1] ovl: setxattr: don't deadlock when called from
 ima_fix_xattr.
Date: Mon, 30 May 2016 22:15:31 -0400
Message-ID: <201605310216.u4V2DWBF016385@mx0a-001b2d01.pphosted.com>
References: <1463611500.2465.22.camel@linux.vnet.ibm.com>
	 <1463725718-2461-1-git-send-email-kli@iki.fi>
	 <1463754087.2763.17.camel@linux.vnet.ibm.com>
	 <20160520162937.GU14480@ZenIV.linux.org.uk>
	 <1463763633.2763.34.camel@linux.vnet.ibm.com>
	 <CAH4bDXjHjPSYAoQB8VODcDG2MRz30ZQqtrm+x7BWG-2X8qhGAg@mail.gmail.com>
	 <20160530141015.GC5758@veci.piliscsaba.szeredi.hu>
	 <20160530165007.GA14480@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63450 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1162675AbcEaCQi (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 30 May 2016 22:16:38 -0400
Received: from pps.filterd (m0082756.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u4V2DWBF016385
	for <linux-unionfs@vger.kernel.org>; Mon, 30 May 2016 22:16:37 -0400
Received: from e23smtp05.au.ibm.com (e23smtp05.au.ibm.com [202.81.31.147])
	by mx0a-001b2d01.pphosted.com with ESMTP id 238v7sdwc7-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-unionfs@vger.kernel.org>; Mon, 30 May 2016 22:16:36 -0400
Received: from localhost
	by e23smtp05.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-unionfs@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
	Tue, 31 May 2016 12:16:33 +1000
In-Reply-To: <20160530165007.GA14480@ZenIV.linux.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Krisztian Litkey <kli@iki.fi>, linux-unionfs@vger.kernel.org, Krisztian Litkey <krisztian.litkey@intel.com>, linux-security-module <linux-security-module@vger.kernel.org>, linux-kernel@vger.kernel.org

On Mon, 2016-05-30 at 17:50 +0100, Al Viro wrote:
> 	Only tangentially related, but... that bug had been discussed,
> without any results: the fallback in ima_d_path() to ->d_name.name is
> completely broken.  There is no warranty whatsoever that dentry won't be
> renamed, with its earlier (too long to be embedded into dentry itself)
> ->d_name.name getting freed.  Right under your code.

Isn't i_mutex required?

> 
> 	Could we please get rid of that thing?  "A message in a near-oom
> situation might be less informative than we'd like" is better than
> "this code might end up dereferencing freed memory".
> 
> 	Another similar bug is in ima_collect_measurement() -
>         const char *filename = file->f_path.dentry->d_name.name;
> 	...
>                 integrity_audit_msg(AUDIT_INTEGRITY_DATA, inode,
>                                     filename, "collect_data", audit_cause,
> with no warranty whatsoever that you are not passing a pointer to freed
> memory.  The same goes for ima_eventname_init_common() -
>         if (event_data->file) {
>                 cur_filename = event_data->file->f_path.dentry->d_name.name;
>                 cur_filename_len = strlen(cur_filename);
>         } else  
> ...
>         return ima_write_template_field_data(cur_filename, cur_filename_len,
>                                              DATA_FMT_STRING, field_data);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
