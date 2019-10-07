From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] ovl: filter of trusted xattr results in audit
Date: Mon, 7 Oct 2019 18:48:28 +0200
Message-ID: <20191007164828.GB1090238@kroah.com>
References: <20191007160918.29504-1-salyzyn@android.com>
 <20191007161616.GA988623@kroah.com>
 <20191007161725.GB988623@kroah.com>
 <7c610f92-5e1f-32ef-0a60-ed47ea999fe3@android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7c610f92-5e1f-32ef-0a60-ed47ea999fe3@android.com>
Sender: stable-owner@vger.kernel.org
To: Mark Salyzyn <salyzyn@android.com>
Cc: linux-kernel@vger.kernel.org, kernel-team@android.com, linux-security-module@vger.kernel.org, stable@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Mon, Oct 07, 2019 at 09:42:08AM -0700, Mark Salyzyn wrote:
> 
> <sigh>
> 
> Now what is the playbook, we have three options in order of preference:
> 
> 1) #ifdef MODULE use capable() to preserve API, add a short comment about
> the side effects if overlayfs is used as a module.
> 
> 2) export has_capability_nodaudit (proc and oom_kill use it, and are both
> built-in only), but affect the 3.18 API at near EOL. AFAIK no one wants
> that?

I'll just do this.  3.18 is EOL, this is only being done for a
distro-specific tree (i.e. AOSP).

> 3) Do nothing more. Make this a distro concern only. Leave this posted as a
> back-port for the record, but never merged, for those that are _interested_
> and declare 3.18 stable as noisy for sepolicy and overlayfs under some usage
> patterns with few user space mitigation unless they explicitly take this
> back-port into their tree (eg: android common kernel) if used built-in. This
> way, in 3.18.y at least the module and built-in version behave the _same_ in
> stable.

I'll just add the export to the patch and check this into AOSP, thanks!

greg k-h
