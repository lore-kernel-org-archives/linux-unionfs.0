From: Mark Salyzyn <salyzyn@android.com>
Subject: Re: overlayfs: caller_credentials option bypass creator_cred
Date: Mon, 18 Jun 2018 12:18:25 -0700
Message-ID: <f141f883-0dbd-10ea-83b9-a1b38119b0c5@android.com>
References: <20180618154222.19279-1-salyzyn@android.com>
 <20180618185448.GA8749@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180618185448.GA8749@redhat.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, Jonathan Corbet <corbet@lwn.net>, linux-unionfs@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On 06/18/2018 11:54 AM, Vivek Goyal wrote:
> On Mon, Jun 18, 2018 at 08:42:15AM -0700, Mark Salyzyn wrote:
>> All accesses to the lower filesystems reference the creator (mount)
>> and not the source context.  This is a security issue.
> Can you elaborate with an example that how this is a security issue.
> mounter's check is in addition to caller's check. So we have two
> checks in ovl_permission(). overlay inode gets the credentials from
> underlying inode and we first check if caller is allowed to the
> operation and if that's allowed, then we check if mounter is allowed
> to do the operation.
init which does the mount and represents the creator_cred which is 
granted a restricted MAC to do just what it needs to do, eg mount, but 
not be able to access the files. The caller comes in and is rejected 
because init domain is not allowed, even though the caller's domain is. 
MAC does not require overlap in privileges between the creator and the user.

-- Mark
