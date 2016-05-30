From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v3 1/1] ovl: setxattr: don't deadlock when called from
 ima_fix_xattr.
Date: Mon, 30 May 2016 17:50:07 +0100
Message-ID: <20160530165007.GA14480@ZenIV.linux.org.uk>
References: <1463611500.2465.22.camel@linux.vnet.ibm.com>
 <1463725718-2461-1-git-send-email-kli@iki.fi>
 <1463754087.2763.17.camel@linux.vnet.ibm.com>
 <20160520162937.GU14480@ZenIV.linux.org.uk>
 <1463763633.2763.34.camel@linux.vnet.ibm.com>
 <CAH4bDXjHjPSYAoQB8VODcDG2MRz30ZQqtrm+x7BWG-2X8qhGAg@mail.gmail.com>
 <20160530141015.GC5758@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160530141015.GC5758@veci.piliscsaba.szeredi.hu>
Sender: owner-linux-security-module@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Krisztian Litkey <kli@iki.fi>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-unionfs@vger.kernel.org, Krisztian Litkey <krisztian.litkey@intel.com>, linux-security-module <linux-security-module@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

	Only tangentially related, but... that bug had been discussed,
without any results: the fallback in ima_d_path() to ->d_name.name is
completely broken.  There is no warranty whatsoever that dentry won't be
renamed, with its earlier (too long to be embedded into dentry itself)
->d_name.name getting freed.  Right under your code.

	Could we please get rid of that thing?  "A message in a near-oom
situation might be less informative than we'd like" is better than
"this code might end up dereferencing freed memory".

	Another similar bug is in ima_collect_measurement() -
        const char *filename = file->f_path.dentry->d_name.name;
	...
                integrity_audit_msg(AUDIT_INTEGRITY_DATA, inode,
                                    filename, "collect_data", audit_cause,
with no warranty whatsoever that you are not passing a pointer to freed
memory.  The same goes for ima_eventname_init_common() -
        if (event_data->file) {
                cur_filename = event_data->file->f_path.dentry->d_name.name;
                cur_filename_len = strlen(cur_filename);
        } else  
...
        return ima_write_template_field_data(cur_filename, cur_filename_len,
                                             DATA_FMT_STRING, field_data);
