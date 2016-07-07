From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 1/5] security, overlayfs: provide copy up security hook
 for unioned files
Date: Thu, 7 Jul 2016 14:44:13 -0700
Message-ID: <2e7462e4-c84b-a6cf-74d3-35bf68048a61@schaufler-ca.com>
References: <1467733854-6314-1-git-send-email-vgoyal@redhat.com>
 <1467733854-6314-2-git-send-email-vgoyal@redhat.com>
 <63906f0e-25cf-266b-6df9-18317f1e7c59@schaufler-ca.com>
 <20160707203329.GD11036@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20160707203329.GD11036@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: miklos@szeredi.hu, sds@tycho.nsa.gov, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-security-module@vger.kernel.org, dwalsh@redhat.com, dhowells@redhat.com, pmoore@redhat.com, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>
List-Id: linux-unionfs@vger.kernel.org

On 7/7/2016 1:33 PM, Vivek Goyal wrote:
> On Tue, Jul 05, 2016 at 12:36:17PM -0700, Casey Schaufler wrote:
>> On 7/5/2016 8:50 AM, Vivek Goyal wrote:
>>> Provide a security hook to label new file correctly when a file is copied
>>> up from lower layer to upper layer of a overlay/union mount.
>>>
>>> This hook can prepare and switch to a new set of creds which are suitable
>>> for new file creation during copy up. Caller should revert to old creds
>>> after file creation.
>>>
>>> In SELinux, newly copied up file gets same label as lower file for
>>> non-context mounts. But it gets label specified in mount option context=
>>> for context mounts.
>>>
>>> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>>> ---
>>>  fs/overlayfs/copy_up.c    |  8 ++++++++
>>>  include/linux/lsm_hooks.h | 13 +++++++++++++
>>>  include/linux/security.h  |  6 ++++++
>>>  security/security.c       |  8 ++++++++
>>>  security/selinux/hooks.c  | 27 +++++++++++++++++++++++++++
>>>  5 files changed, 62 insertions(+)
>>>
>>> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
>>> index 80aa6f1..90dc362 100644
>>> --- a/fs/overlayfs/copy_up.c
>>> +++ b/fs/overlayfs/copy_up.c
>>> @@ -246,6 +246,7 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
>>>  	struct dentry *upper = NULL;
>>>  	umode_t mode = stat->mode;
>>>  	int err;
>>> +	const struct cred *old_creds = NULL;
>>>  
>>>  	newdentry = ovl_lookup_temp(workdir, dentry);
>>>  	err = PTR_ERR(newdentry);
>>> @@ -258,10 +259,17 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
>>>  	if (IS_ERR(upper))
>>>  		goto out1;
>>>  
>>> +	err = security_inode_copy_up(dentry, &old_creds);
>>> +	if (err < 0)
>>> +		goto out2;
>>> +
>>>  	/* Can't properly set mode on creation because of the umask */
>>>  	stat->mode &= S_IFMT;
>>>  	err = ovl_create_real(wdir, newdentry, stat, link, NULL, true);
>>>  	stat->mode = mode;
>>> +	if (old_creds)
>>> +		revert_creds(old_creds);
>>> +
>>>  	if (err)
>>>  		goto out2;
>> I don't much care for the way part of the credential manipulation
>> is done in the caller and part is done the the security module.
>> If the caller is going to restore the old state, the caller should
>> save the old state. 
> One advantage of current patches is that we switch to new creds only if
> it is needed. For example, if there are no LSMs loaded,

Point.

>  then there is
> no need to modify creds and make a switch to new creds.

I'm not a fan of cred flipping. There are too many ways for it to go
wrong. Consider interrupts. I assume you've ruled that out as a possibility
in the caller, but I still think the practice is dangerous.

I greatly prefer "create and set attributes" to "change cred, create and
reset cred". I know that has it's own set of problems, including races
and faking privilege. 
 

> But if I start allocating new creds and save old state in caller, then
> caller always has to do it (irrespective of the fact whether any LSM
> modified the creds or not).

It starts getting messy when I have two modules that want to
change change the credential. Each module will have to check to
see if a module called before it has allocated a new cred.

>
> Thanks
> Vivek
>

