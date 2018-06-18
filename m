From: Mark Salyzyn <salyzyn@android.com>
Subject: Re: overlayfs: caller_credentials option bypass creator_cred
Date: Mon, 18 Jun 2018 14:59:50 -0700
Message-ID: <aecdeaca-74cf-54b1-3ea9-4751972074f5@android.com>
References: <20180618154222.19279-1-salyzyn@android.com>
 <20180618185448.GA8749@redhat.com>
 <f141f883-0dbd-10ea-83b9-a1b38119b0c5@android.com>
 <20180618194345.GA15973@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180618194345.GA15973@redhat.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, Jonathan Corbet <corbet@lwn.net>, linux-unionfs@vger.kernel.org, linux-doc@vger.kernel.org, Daniel Walsh <dwalsh@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>
List-Id: linux-unionfs@vger.kernel.org

On 06/18/2018 12:43 PM, Vivek Goyal wrote:
> Will it be acceptable to write security policies in such a way so that
> mounter has access as well.
Unfortunately No. Policy of minimizing attack surface for a contained 
root service (init in this case). Just because it can mount, does not 
mean it can modify critical content; an attacker could use this to open 
a hole.

> Current model does assume that mounter has privileges on underlying files.

Only ones it appears to need is the workdir AFAIK, had to add ability to 
create in the <wordir> xattr in order to enable r/w mounts later. 
Although not all corners were tested, I did not see any copy_up issues 
b/c the caller had the privs in the Android security model when mounted 
with this new flag.

-- Mark
