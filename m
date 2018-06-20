From: Mark Salyzyn <salyzyn@android.com>
Subject: Re: overlayfs: caller_credentials option bypass creator_cred
Date: Wed, 20 Jun 2018 08:28:30 -0700
Message-ID: <d8e6c8ce-6305-67d8-6213-5460e5d0d88c@android.com>
References: <20180618154222.19279-1-salyzyn@android.com>
 <20180618185448.GA8749@redhat.com>
 <f141f883-0dbd-10ea-83b9-a1b38119b0c5@android.com>
 <20180618194345.GA15973@redhat.com>
 <aecdeaca-74cf-54b1-3ea9-4751972074f5@android.com>
 <20180619143617.GC22657@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180619143617.GC22657@redhat.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, Jonathan Corbet <corbet@lwn.net>, linux-unionfs@vger.kernel.org, linux-doc@vger.kernel.org, Daniel Walsh <dwalsh@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>
List-Id: linux-unionfs@vger.kernel.org

On 06/19/2018 07:36 AM, Vivek Goyal wrote:
> On Mon, Jun 18, 2018 at 02:59:50PM -0700, Mark Salyzyn wrote:
> So in this system all callers are priviliged and have the capability to
> mknod and set trusted xattrs.
This is true of the callers that make adjustments (in Android's Case 
this is an su context provided to the adb tool for sync and push). More 
importantly the large variety of callers have the passive/read MAC 
credentials for their domain set of files; where the mounter/creator 
does not.
>   (Amir mentioned the reason why we switch
> creds). If not, then file unlink (Should do mknod), lower non-empty directory
> rename (should set trusted REDIRECT) and bunch of other operations should fail.

Hmmm, neither was part of my test plan b/c these operations are more 
esoteric for development ... need to add them and address them.

Thanks all (You, Eric, Amir and private) for your comments, will 
regroup, test and address concerns!

-- Mark
